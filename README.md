ClinicPulse – Token Management System

ClinicPulse is a simple Token Management System for a clinic.
It allows generating daily tokens for patients based on doctors.
Each doctor has a separate token sequence that resets every day.

🚀 Tech Stack

Frontend: React (TypeScript, CSS)
Backend: Supabase

🌐 Deployed URL

https://clinicpulses.netlify.app/

📌 Features

Add Doctor

List Doctors

Generate Token

Auto-increment token per doctor per day

Daily token reset

View Active Tokens

View Completed Tokens

Mark Token as Completed

🗄 Database Schema

{
  "database": "clinicpulse",
  "tables": [
    {
      "table_name": "doctors",
      "columns": [
        {
          "name": "doctor_id",
          "type": "uuid",
          "primary_key": true
        },
        {
          "name": "name",
          "type": "text",
          "nullable": false
        },
        {
          "name": "specialization",
          "type": "text",
          "nullable": false
        },
        {
          "name": "created_at",
          "type": "timestamp",
          "default": "now()"
        }
      ]
    },
    {
      "table_name": "tokens",
      "columns": [
        {
          "name": "token_id",
          "type": "uuid",
          "primary_key": true
        },
        {
          "name": "doctor_id",
          "type": "uuid",
          "foreign_key": {
            "references": "doctors.doctor_id",
            "on_delete": "cascade"
          }
        },
        {
          "name": "patient_name",
          "type": "text",
          "nullable": false
        },
        {
          "name": "patient_phone",
          "type": "text",
          "nullable": false
        },
        {
          "name": "token_number",
          "type": "integer",
          "nullable": false
        },
        {
          "name": "token_date",
          "type": "date",
          "nullable": false
        },
        {
          "name": "status",
          "type": "text",
          "default": "active"
        },
        {
          "name": "created_at",
          "type": "timestamp",
          "default": "now()"
        }
      ],
      "constraints": [
        {
          "type": "unique",
          "columns": ["doctor_id", "token_date", "token_number"]
        }
      ]
    }
  ]
}





⚙️ Installation Steps
1️⃣ Clone Repository
git clone https://github.com/your-username/clinicpulse.git
cd clinicpulse

2️⃣ Install Dependencies
npm install

3️⃣ Setup Environment Variables

Create a .env file:

VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

4️⃣ Run Project
npm run dev

📄 How It Works

Token number is generated per doctor per day

Token resets automatically when date changes

Concurrency handled at database level

Frontend connects to Supabase using real API calls
