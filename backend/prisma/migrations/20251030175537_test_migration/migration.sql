-- CreateEnum
CREATE TYPE "OnRampStatus" AS ENUM ('Success', 'Failure', 'Proccessing');

-- CreateTable
CREATE TABLE "Admin" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(256) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "password" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Admin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Buyer" (
    "id" TEXT NOT NULL,
    "organization_type" TEXT NOT NULL,
    "organization_name" VARCHAR(256) NOT NULL,
    "organization_email" VARCHAR(256) NOT NULL,
    "phone_no" VARCHAR(15) NOT NULL,
    "password" TEXT NOT NULL,
    "pan_no" TEXT,
    "aadhar_no" INTEGER,
    "gst_no" TEXT,
    "registration_no" VARCHAR(256),
    "address" TEXT,
    "otp_code" TEXT,
    "otp_expires_at" TIMESTAMP(3),
    "isVerified" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Buyer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Seller" (
    "id" TEXT NOT NULL,
    "organization_name" VARCHAR(256) NOT NULL,
    "organization_email" VARCHAR(256) NOT NULL,
    "phone_no" VARCHAR(15) NOT NULL,
    "password" TEXT NOT NULL,
    "pan_no" TEXT,
    "aadhar_no" INTEGER,
    "certificate_standard" TEXT,
    "address" TEXT,
    "otp_code" TEXT,
    "otp_expires_at" TIMESTAMP(3),
    "isVerified" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Seller_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "status" "OnRampStatus" NOT NULL,
    "amount" INTEGER NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "seller_id" TEXT NOT NULL,
    "buyer_id" TEXT NOT NULL,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnRampTransaction" (
    "id" TEXT NOT NULL,
    "status" "OnRampStatus" NOT NULL,
    "token" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "buyer_id" TEXT NOT NULL,

    CONSTRAINT "OnRampTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Project" (
    "id" TEXT NOT NULL,
    "project_no" INTEGER NOT NULL,
    "project_name" TEXT NOT NULL,
    "authority" TEXT,
    "seller_id" TEXT NOT NULL,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Admin_email_key" ON "Admin"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Buyer_organization_name_key" ON "Buyer"("organization_name");

-- CreateIndex
CREATE UNIQUE INDEX "Buyer_organization_email_key" ON "Buyer"("organization_email");

-- CreateIndex
CREATE UNIQUE INDEX "Buyer_pan_no_key" ON "Buyer"("pan_no");

-- CreateIndex
CREATE UNIQUE INDEX "Buyer_aadhar_no_key" ON "Buyer"("aadhar_no");

-- CreateIndex
CREATE UNIQUE INDEX "Seller_organization_name_key" ON "Seller"("organization_name");

-- CreateIndex
CREATE UNIQUE INDEX "Seller_organization_email_key" ON "Seller"("organization_email");

-- CreateIndex
CREATE UNIQUE INDEX "Seller_pan_no_key" ON "Seller"("pan_no");

-- CreateIndex
CREATE UNIQUE INDEX "Seller_aadhar_no_key" ON "Seller"("aadhar_no");

-- CreateIndex
CREATE UNIQUE INDEX "OnRampTransaction_token_key" ON "OnRampTransaction"("token");

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_seller_id_fkey" FOREIGN KEY ("seller_id") REFERENCES "Seller"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_buyer_id_fkey" FOREIGN KEY ("buyer_id") REFERENCES "Buyer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnRampTransaction" ADD CONSTRAINT "OnRampTransaction_buyer_id_fkey" FOREIGN KEY ("buyer_id") REFERENCES "Buyer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_seller_id_fkey" FOREIGN KEY ("seller_id") REFERENCES "Seller"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
