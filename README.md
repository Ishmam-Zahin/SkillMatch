<div align="center">

# 🎯 SkillMatch

### A Freelance Job Marketplace with Smart Skill Matching

Built with **Flutter**, **Dart**, **BLoC**, and **Supabase**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![BLoC](https://img.shields.io/badge/State-BLoC-5C2D91?style=for-the-badge)](https://bloclibrary.dev)

</div>

---

## 📸 Screenshots

<div align="center">

| | | |
|---|---|---|
| ![Screenshot 1](assets/screenshots/1.png) | ![Screenshot 2](assets/screenshots/2.png) | ![Screenshot 3](assets/screenshots/3.png) |
| ![Screenshot 4](assets/screenshots/4.png) | ![Screenshot 5](assets/screenshots/5.png) | |

</div>

---

## ✨ Overview

**SkillMatch** is a full-featured freelance job marketplace that connects clients with skilled professionals. Users can create accounts, post work opportunities, browse and filter jobs, communicate through comments, and manage their listings — all wrapped around a **skill-based job matching system** that ranks opportunities by relevance instead of showing a flat, unsorted list.

Unlike a typical CRUD job board, SkillMatch computes the overlap between a user's skills and a job's requirements directly in **PostgreSQL**, using set-based SQL functions — surfacing the most relevant jobs first.

---

## 🚀 Key Features

- 🎯 **Skill-Based Job Matching** — Jobs are ranked and recommended based on skill overlap between user profiles and job requirements, computed via Postgres functions.
- 🔐 **Secure Authentication** — Email-based signup/login handled through Supabase Auth, with Row-Level Security (RLS) policies controlling data access.
- 💼 **Job Marketplace** — Post, browse, and filter freelance jobs by category, deadline, and description.
- 🔍 **Search** — Find users, companies, and job-related profiles across the platform.
- 👥 **User Profiles** — View personal and public profiles, including posted jobs and skills.
- 💬 **Comments** — Discuss job requirements directly on listings.
- 📊 **Applicant Tracking** — Applicant counts auto-increment via database triggers whenever someone applies.
- ⚙️ **Job Management** — Activate, deactivate, or delete your own job listings anytime.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter, Dart |
| **State Management** | BLoC |
| **Backend / Database** | Supabase (PostgreSQL) |
| **Auth** | Supabase Auth (Email-based) |
| **UI** | Material Design |

---

## 🧩 Architecture Highlights

- **Postgres Views** (`get_job_list`, `search_users`) for efficient joined reads across `jobs`, `job_types`, and `auth.users`.
- **Postgres Functions** (`get_job_detail`, `get_comments`) with `SECURITY DEFINER` for controlled, joined data access.
- **Database Triggers** to auto-increment applicant counts on `job_applicant` inserts.
- **Row-Level Security (RLS)** policies to govern read/write access per table.
- **Skill-matching logic** via array intersection in SQL for ranking job relevance.

---

## 📱 Screens

- Login / Registration (with profile image upload)
- Job Listings (with category filters & match ranking)
- Job Details (owner info, applicants, apply, comments)
- Post a New Job
- Search
- User Profile (own & others')
- Job Management (activate/deactivate/delete)

---

## 📦 Getting Started

```bash
# Clone the repository
git clone https://github.com/Ishmam-Zahin/Flutter-FreelanceApp-Project.git
cd Flutter-FreelanceApp-Project

# Install dependencies
flutter pub get

# Add your Supabase credentials
# (create a .env or update your Supabase config file with your project URL & anon key)

# Run the app
flutter run
```

---

## 🗄️ Database Setup

The full PostgreSQL schema (tables, views, functions, and triggers) is available in [`schema.sql`](./schema.sql). Run it in the Supabase SQL Editor to set up your backend, then configure RLS policies as needed for your environment.

---

## 👤 Author

**Md. Ishmam Zahin**
🔗 [Portfolio](https://ishmam-zahin.github.io/My-Portfolio) · 💻 [GitHub](https://github.com/Ishmam-Zahin)

---

<div align="center">

If you found this project interesting, consider giving it a ⭐

</div>