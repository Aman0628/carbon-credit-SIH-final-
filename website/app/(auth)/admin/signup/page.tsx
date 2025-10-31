'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Card } from '@/components/ui/Card';
import { Input } from '@/components/ui/Input';
import { Button } from '@/components/ui/Button';
import { Alert } from '@/components/ui/Alert';
import { adminApi, handleApiError } from '@/lib/api';

export default function AdminSignupPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
    admin_key: '',
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
    // Clear error for this field
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }));
    }
  };

  const validate = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.name) {
      newErrors.name = 'Name is required';
    }

    if (!formData.email) {
      newErrors.email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = 'Email is invalid';
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 8) {
      newErrors.password = 'Password must be at least 8 characters';
    }

    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    if (!formData.admin_key) {
      newErrors.admin_key = 'Admin key is required';
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
      const response = await adminApi.signup(signupData);

      if (response.data.success) {
        setAlert({
          type: 'success',
          message: 'Account created successfully! Redirecting to login...',
        });

        setTimeout(() => {
          router.push('/auth/admin/login');
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
          Admin Registration
        </h1>
        <p className="text-gray-600">Create your admin account</p>
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
          name="name"
          label="Full Name"
          placeholder="John Doe"
          value={formData.name}
          onChange={handleChange}
          error={errors.name}
          required
        />

        <Input
          type="email"
          name="email"
          label="Email Address"
          placeholder="admin@example.com"
          value={formData.email}
          onChange={handleChange}
          error={errors.email}
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

        <Input
          type="password"
          name="admin_key"
          label="Admin Key"
          placeholder="Enter admin key"
          value={formData.admin_key}
          onChange={handleChange}
          error={errors.admin_key}
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
            href="/auth/admin/login"
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
