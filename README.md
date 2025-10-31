# ECO-Ex - Carbon Credit Marketplace

A complete platform for trading carbon credits with Admin, Buyer, and Seller roles.

## Quick Start

### 1. Backend Setup
```bash
cd backend
npm install
npm run dev
```
Backend runs on: http://localhost:4000

### 2. Frontend Setup
```bash
cd website
npm install
npm run dev
```
Frontend runs on: http://localhost:3000

## Admin Flow (Complete Testing Guide)

### Step 1: Create Admin Account
1. Go to http://localhost:3000
2. Click "Admin" → "Sign Up"
3. Fill in:
   - Name: Admin User
   - Email: admin@test.com
   - Password: admin123
   - Admin Key: `ADMIN_SECRET_KEY` (from backend .env)
4. Click Sign Up

### Step 2: Login as Admin
1. Click "Admin" → "Login"
2. Enter email: admin@test.com
3. Enter password: admin123
4. Click Login → Redirects to `/admin/dashboard`

### Step 3: Admin Dashboard Features
**Dashboard View:**
- Total Buyers count
- Total Sellers count
- Total Projects count
- Total Transactions count

**User Management:**
- Click "Verify Users" tab
- See list of all buyers and sellers
- Click "Verify" button to approve users
- Search users by name

**Profile Management:**
- Click "Profile" link in dashboard
- View/Edit admin details
- Change password

### Step 4: Test Other User Types

**Create Buyer Account:**
1. Logout from admin
2. Click "Buyer" → "Sign Up"
3. Fill organization details
4. Login as admin and verify the buyer

**Create Seller Account:**
1. Logout
2. Click "Seller" → "Sign Up"
3. Fill organization details
4. Login as admin and verify the seller

**Seller Creates Project:**
1. Login as seller
2. Go to "My Projects"
3. Click "Create New Project"
4. Fill project details
5. Submit

**Buyer Shops:**
1. Login as buyer
2. Go to "Marketplace"
3. Browse projects
4. Click project to view details
5. Add to cart
6. Go to cart
7. Checkout

## Project Structure

### Backend (`/backend`)
```
src/
├── controllers/     # Request handlers
├── services/        # Business logic
├── routes/          # API routes
├── middleware/      # Auth middleware
├── config/          # Database config
└── index.ts         # Server entry

prisma/
├── schema.prisma    # Database models
└── migrations/      # DB migrations
```

**Key Backend Features:**
- JWT Authentication
- Email OTP Verification
- Profile Management
- Cart & Orders System
- Project CRUD
- User Verification

### Frontend (`/website`)
```
app/
├── (auth)/          # Login/Signup pages
│   ├── admin/
│   ├── buyer/
│   └── seller/
├── admin/           # Admin dashboard & pages
├── buyer/           # Buyer dashboard & pages
├── seller/          # Seller dashboard & pages
└── page.tsx         # Homepage

lib/
└── api.ts          # API client

components/
└── ui/             # Reusable UI components
```

## Environment Variables

### Backend (.env)
```
DATABASE_URL="your_postgres_url"
JWT_SECRET="your_jwt_secret"
ADMIN_KEY="ADMIN_SECRET_KEY"
EMAIL_USER="your_email"
EMAIL_PASS="your_email_password"
```

### Frontend (.env.local)
```
NEXT_PUBLIC_API_URL="http://localhost:4000/api/v1"
```

## Database Models

- **Admin**: Platform administrators
- **Buyer**: Organizations buying credits
- **Seller**: Organizations selling credits
- **Project**: Carbon credit projects
- **CartItem**: Shopping cart items
- **Order**: Purchase orders
- **OrderItem**: Order line items

## API Endpoints

### Admin
- POST `/api/v1/admin/signup` - Register admin
- POST `/api/v1/admin/login` - Admin login
- GET `/api/v1/admin/dashboard` - Dashboard stats
- GET `/api/v1/admin/users` - List all users
- POST `/api/v1/admin/verify-user` - Verify buyer/seller
- GET/PUT `/api/v1/admin/profile` - Profile management

### Buyer
- POST `/api/v1/buyer/signup` - Register
- POST `/api/v1/buyer/login` - Login
- GET `/api/v1/buyer/dashboard` - Dashboard
- GET/PUT `/api/v1/buyer/profile` - Profile
- GET/POST `/api/v1/buyer/cart` - Cart management
- POST `/api/v1/buyer/orders` - Create order
- GET `/api/v1/buyer/orders` - Order history

### Seller
- POST `/api/v1/seller/signup` - Register
- POST `/api/v1/seller/login` - Login
- GET `/api/v1/seller/dashboard` - Dashboard
- GET/PUT `/api/v1/seller/profile` - Profile

### Projects
- GET `/api/v1/projects` - List all projects
- POST `/api/v1/projects` - Create project (seller only)
- GET `/api/v1/projects/:id` - Project details
- PUT `/api/v1/projects/:id` - Update project
- DELETE `/api/v1/projects/:id` - Delete project

## Testing Checklist

- [ ] Admin signup and login works
- [ ] Admin can view dashboard stats
- [ ] Admin can verify buyers/sellers
- [ ] Buyer signup and login works
- [ ] Buyer can browse marketplace
- [ ] Buyer can add items to cart
- [ ] Buyer can checkout
- [ ] Seller signup and login works
- [ ] Seller can create projects
- [ ] Seller can view their projects
- [ ] All users can manage profiles
- [ ] All users can change passwords

## Troubleshooting

**404 Errors on Auth Pages:**
- Restart Next.js dev server: `npm run dev`
- Clear `.next` folder and restart

**Backend Connection Issues:**
- Check DATABASE_URL in backend/.env
- Ensure Postgres database is accessible
- Run `npx prisma migrate dev`

**Login Not Working:**
- Check JWT_SECRET is set in backend/.env
- Check NEXT_PUBLIC_API_URL in website/.env.local
- Open browser console for errors

---

**Built with:** Next.js 15, Express.js, Prisma, PostgreSQL, TypeScript
