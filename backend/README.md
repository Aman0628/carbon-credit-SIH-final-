for backend setup
run npm i


on .env file -> add Prisma Url and Admin_key
EMAIL_USER → your Gmail address.
EMAIL_PASS → App Password, not your Gmail password.
You generate it in your Google Account → Security → App Password
Requires 2FA enabled.


migrate prisma file -> npx prisma migrate dev
generate prisma client -> npx prisma generate
for build -> npm run build
for start -> npm run start