'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Card } from '@/components/ui/Card';
import { Input } from '@/components/ui/Input';
import { Button } from '@/components/ui/Button';
import { Alert } from '@/components/ui/Alert';
import { sellerApi, handleApiError } from '@/lib/api';

export default function SellerSignupPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    organization_name: '',
    organization_email: '',
    phone_no: '',
    password: '',
    confirmPassword: '',
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isLoading, setIsLoading] = useState(false);
  const [alert, setAlert] = useState<{
    type: 'success' | 'error';
    message: string;
  } | null>(null);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }));
    }
  };

  const validate = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.organization_name) {
      newErrors.organization_name = 'Organization name is required';
    }

    if (!formData.organization_email) {
      newErrors.organization_email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.organization_email)) {
      newErrors.organization_email = 'Email is invalid';
    }

    if (!formData.phone_no) {
      newErrors.phone_no = 'Phone number is required';
    } else if (!/^\d{10}$/.test(formData.phone_no)) {
      newErrors.phone_no = 'Phone number must be 10 digits';
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 8) {
      newErrors.password = 'Password must be at least 8 characters';
    }

    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setAlert(null);

    if (!validate()) return;

    setIsLoading(true);

    try {
      const { confirmPassword: _confirmPassword, ...signupData } = formData;
      const response = await sellerApi.signup(signupData);

      if (response.data.success) {
        setAlert({
          type: 'success',
          message:
            'Account created successfully! Please verify your email. Redirecting...',
        });

        setTimeout(() => {
          router.push('/auth/seller/login');
        }, 2000);
      }
    } catch (error) {
      setAlert({
        type: 'error',
        message: handleApiError(error),
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card>
      <div className="text-center mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Seller Registration
        </h1>
        <p className="text-gray-600">Create your seller account</p>
      </div>

      {alert && (
        <Alert
          type={alert.type}
          message={alert.message}
          onClose={() => setAlert(null)}
        />
      )}

      <form onSubmit={handleSubmit} className="space-y-4">
        <Input
          type="text"
          name="organization_name"
          label="Organization Name"
          placeholder="Green Energy Corp"
          value={formData.organization_name}
          onChange={handleChange}
          error={errors.organization_name}
          required
        />

        <Input
          type="email"
          name="organization_email"
          label="Organization Email"
          placeholder="contact@greenenergy.com"
          value={formData.organization_email}
          onChange={handleChange}
          error={errors.organization_email}
          required
        />

        <Input
          type="tel"
          name="phone_no"
          label="Phone Number"
          placeholder="1234567890"
          value={formData.phone_no}
          onChange={handleChange}
          error={errors.phone_no}
          required
        />

        <Input
          type="password"
          name="password"
          label="Password"
          placeholder="At least 8 characters"
          value={formData.password}
          onChange={handleChange}
          error={errors.password}
          required
        />

        <Input
          type="password"
          name="confirmPassword"
          label="Confirm Password"
          placeholder="Re-enter your password"
          value={formData.confirmPassword}
          onChange={handleChange}
          error={errors.confirmPassword}
          required
        />

        <Button type="submit" isLoading={isLoading}>
          Create Account
        </Button>
      </form>

      <div className="mt-6 text-center">
        <p className="text-sm text-gray-600">
          Already have an account?{' '}
          <Link
            href="/auth/seller/login"
            className="text-green-600 hover:text-green-700 font-medium"
          >
            Sign in
          </Link>
        </p>
      </div>

      <div className="mt-4 text-center">
        <Link href="/" className="text-sm text-gray-500 hover:text-gray-700">
          ← Back to home
        </Link>
      </div>
    </Card>
  );
}
