'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { adminApi, buyerApi, sellerApi } from '@/lib/api';

interface NotificationBannerProps {
  userType: 'admin' | 'buyer' | 'seller' | null;
}

export default function NotificationBanner({
  userType,
}: NotificationBannerProps) {
  const pathname = usePathname();
  const [isProfileIncomplete, setIsProfileIncomplete] = useState(false);
  const [isVisible, setIsVisible] = useState(true);

  useEffect(() => {
    const checkProfileCompleteness = async () => {
      if (!userType) {
        setIsProfileIncomplete(false);
        return;
      }

      try {
        let response;
        if (userType === 'admin') {
          response = await adminApi.getProfile();
          // Admin profile is complete if email and name are present
          const isComplete = response.data.email && response.data.name;
          setIsProfileIncomplete(!isComplete);
        } else if (userType === 'buyer') {
          response = await buyerApi.getProfile();
          // Buyer profile is incomplete if missing key fields
          const data = response.data;
          const isComplete =
            data.organization_name &&
            data.organization_email &&
            data.phone_no &&
            data.address &&
            data.pan_no &&
            data.gst_no;
          setIsProfileIncomplete(!isComplete);
        } else if (userType === 'seller') {
          response = await sellerApi.getProfile();
          // Seller profile is incomplete if missing key fields
          const data = response.data;
          const isComplete =
            data.organization_name &&
            data.organization_email &&
            data.phone_no &&
            data.address &&
            data.pan_no;
          setIsProfileIncomplete(!isComplete);
        }
      } catch {
        setIsProfileIncomplete(false);
      }
    };

    checkProfileCompleteness();
  }, [userType, pathname]);

  const getProfileLink = () => {
    if (userType === 'admin') return '/admin/profile';
    if (userType === 'buyer') return '/buyer/profile';
    if (userType === 'seller') return '/seller/profile';
    return '/';
  };

  if (!isProfileIncomplete || !isVisible || !userType) {
    return null;
  }

  return (
    <div className="bg-yellow-50 border-b border-yellow-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <svg
              className="w-5 h-5 text-yellow-600"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
              />
            </svg>
            <p className="text-sm text-yellow-800">
              <span className="font-medium">Incomplete Profile:</span> Please
              complete your profile to access all features.
            </p>
          </div>
          <div className="flex items-center space-x-4">
            <Link
              href={getProfileLink()}
              className="text-sm font-medium text-yellow-800 hover:text-yellow-900 underline"
            >
              Complete Now
            </Link>
            <button
              onClick={() => setIsVisible(false)}
              className="text-yellow-600 hover:text-yellow-800"
            >
              <svg
                className="w-5 h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
