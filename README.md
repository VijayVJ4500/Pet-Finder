# Pet-Finder

# 🐾 Pet Finder - Backend Service

The **Pet Finder Backend** is a Node.js-based REST API designed to manage pet information, user details, and adoption data.  
It connects to a MongoDB database and provides APIs for pet listings, user management, and adoption requests.

---

## 🚀 Features

- User and Pet management APIs
- MongoDB integration using Mongoose
- RESTful API endpoints
- Dockerized for easy deployment
- Health check and monitoring setup
- Basic CI/CD workflow via GitHub Actions

---

## 🧱 Tech Stack

- **Node.js** (v20)
- **Express.js**
- **MongoDB** (v6)
- **Docker & Docker Compose**
- **GitHub Actions** for CI/CD
- **Jest / Mocha** for testing (optional)

---



## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/<your-username>/Pet-Finder.git
cd Pet-Finder/petmanagement_backend_rajalakshmi/petmanagement_backend_rajalakshmi
2️⃣ Install Dependencies
Make sure Node.js v20+ and npm are installed.

bash
Copy code
npm install
3️⃣ Environment Variables
Create a .env file inside your backend folder:

bash
Copy code
PORT=5000
NODE_ENV=production
MONGO_URI=mongodb://mongo:27017/petmanagement
4️⃣ Run Locally (without Docker)
bash
Copy code
npm start
Access the app at:
👉 http://localhost:5000

🧪 Run Unit Tests
bash
Copy code
npm test
If no tests exist yet, the GitHub Action will skip with a warning.

🐳 Docker Setup
Build Docker Image
bash
Copy code
docker build -t petfinder-backend:latest -f Dockerfile .
Run Using Docker
bash
Copy code
docker run -d -p 5000:5000 petfinder-backend:latest
🐙 Docker Compose Deployment
The project includes a docker-compose.yml for full stack deployment (Backend + MongoDB):

bash
Copy code
docker compose up -d
This will:

Start a MongoDB container (mongo)

Start the backend container (petfinder-backend)

Expose the backend on port 5000

Access it at:
👉 http://localhost:5000

⚡ CI/CD Workflow (GitHub Actions)
File: .github/workflows/backend-ci.yml

The pipeline performs:

Code checkout

Install dependencies & run tests

Build Docker image

Push image to Docker Hub

(Optionally) deploy to a test environment

Secrets required in GitHub:

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

📜 Log Monitoring Script
A monitoring script monitor_petfinder.sh is included for operational automation:

Monitors /var/log/petfinder.log for errors

Rotates logs beyond 10MB

Logs alerts in /var/log/petfinder_alerts.log

Run it with:

##Run it in the background
nohup ./monitor_petfinder.sh &


🧠 Assumptions
MongoDB is running locally or accessible from the container

All environment variables are defined correctly

The backend folder structure follows:

bash
Copy code
petmanagement_backend_rajalakshmi/petmanagement_backend_rajalakshmi
Docker Hub repository exists (<username>/registry or <username>/petfinder-backend)

Tests are optional; pipeline won’t fail if tests are absent
