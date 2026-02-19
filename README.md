ClinicPulse is a simple Token Management System built for clinics to manage daily patient queues.

Each doctor has a separate daily token sequence.
Tokens auto-increment per doctor and reset automatically every day.

🚀 Tech Stack

Frontend: React (TypeScript, CSS)
Backend: Supabase

🌐 Deployed URL

Frontend: https://clinicpulses.netlify.app/

📌 Features

Add Doctor
List Doctors
Generate Token
Auto-increment token per doctor per day
Daily token reset
View Active Tokens
View Completed Tokens
Mark Token as Completed

📂 Database Schema (JSON)

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
          "columns": [
            "doctor_id",
            "token_date",
            "token_number"
          ]
        }
      ]
    }
  ]
}





⚙️ Installation & Setup

1️⃣ Clone Repository

git clone https://github.com/your-username/clinicpulse.git
cd clinicpulse

2️⃣ Install Dependencies

npm install

3️⃣ Setup Environment Variables

Create a .env file in the root folder:

VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key


4️⃣ Run the Project'

npm run dev

🔄 How Token Reset Works

Token number is generated based on doctor_id and CURRENT_DATE

If no token exists for that doctor today → starts from 1

Otherwise → increments the last token number

Since date changes at midnight, tokens automatically reset daily

🔒 Concurrency Handling

Token generation handled inside database function

Unique constraint on:

(doctor_id, token_date, token_number)

Prevents duplicate tokens even if two users generate tokens at the same time

📄 License

This project is developed for internship evaluation and learning purposes.
