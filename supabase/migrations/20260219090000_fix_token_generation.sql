-- Migration to fix "FOR UPDATE is not allowed with aggregate functions" error

-- Fix get_next_token_number function
CREATE OR REPLACE FUNCTION public.get_next_token_number(p_doctor_id UUID, p_date DATE)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_next_number INTEGER;
BEGIN
  -- Lock the doctor record to serialize token generation for this doctor
  PERFORM 1 FROM public.doctors WHERE id = p_doctor_id FOR UPDATE;

  -- Get the max token number for this doctor on this date
  SELECT COALESCE(MAX(token_number), 0) + 1
  INTO v_next_number
  FROM public.tokens
  WHERE doctor_id = p_doctor_id AND token_date = p_date;
  
  RETURN v_next_number;
END;
$$;

-- Fix generate_token function
CREATE OR REPLACE FUNCTION public.generate_token(
  p_doctor_id UUID,
  p_patient_name TEXT,
  p_patient_phone TEXT
)
RETURNS TABLE(token_number INTEGER, token_date DATE, queue_position INTEGER, token_id UUID)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_token_number INTEGER;
  v_date DATE := CURRENT_DATE;
  v_token_id UUID;
BEGIN
  -- Lock the doctor record to serialize token generation for this doctor
  -- This prevents race conditions where two concurrent requests might get the same token number
  PERFORM 1 FROM public.doctors WHERE id = p_doctor_id FOR UPDATE;

  -- Get next token number atomically (safe now that we have the doctor lock)
  SELECT COALESCE(MAX(t.token_number), 0) + 1
  INTO v_token_number
  FROM public.tokens t
  WHERE t.doctor_id = p_doctor_id AND t.token_date = v_date;

  -- Insert new token
  INSERT INTO public.tokens (doctor_id, patient_name, patient_phone, token_number, token_date, status, queue_position)
  VALUES (p_doctor_id, p_patient_name, p_patient_phone, v_token_number, v_date, 'active', v_token_number)
  RETURNING id INTO v_token_id;

  RETURN QUERY SELECT v_token_number, v_date, v_token_number, v_token_id;
END;
$$;
