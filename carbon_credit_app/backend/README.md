# Carbon Trading Backend

Well-structured Node.js backend with Express and Nodemon.

## 📁 Project Structure

```
backend/
├── src/
│   ├── app.js              # Express app configuration
│   ├── config/             # Configuration files
│   │   └── index.js        # Environment variables
│   ├── controllers/        # Request handlers
│   │   └── index.js
│   ├── middleware/         # Custom middleware
│   │   └── index.js
│   ├── models/            # Data models
│   │   └── index.js
│   ├── routes/            # API routes
│   │   └── index.js
│   ├── services/          # Business logic
│   │   └── index.js
│   └── utils/             # Helper functions
│       └── index.js
├── server.js              # Server entry point
├── package.json
├── .env.example          # Environment variables template
├── .gitignore
└── README.md
```

## 🚀 Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Environment setup:**
   ```bash
   cp .env.example .env
   ```

3. **Start development server:**
   ```bash
   npm run dev
   ```

4. **Server runs on:** `http://localhost:5000`

## 📚 API Endpoints

- `GET /` - Welcome message
- `GET /api` - API information

## 🛠️ Scripts

- `npm start` - Production server
- `npm run dev` - Development server with auto-restart

## 📝 Ready for development!

The backend is now properly structured and ready for you to:
- Add routes in `src/routes/`
- Create controllers in `src/controllers/`
- Add middleware in `src/middleware/`
- Define models in `src/models/`
- Implement business logic in `src/services/`
- Add utilities in `src/utils/`