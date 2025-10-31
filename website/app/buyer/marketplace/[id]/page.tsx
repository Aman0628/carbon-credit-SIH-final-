'use client';

import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { projectApi, handleApiError } from '@/lib/api';

interface Project {
  project_id: string;
  project_name: string;
  project_description: string;
  project_location: string;
  carbon_credits_available: number;
  price_per_credit: number;
  image_url?: string;
  project_status: string;
  seller: {
    seller_id: string;
    organization_name: string;
    organization_email: string;
    phone_no: string;
    is_verified: boolean;
  };
  created_at: string;
}

export default function ProjectDetailPage() {
  const router = useRouter();
  const params = useParams();
  const projectId = params.id as string;

  const [project, setProject] = useState<Project | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [purchaseQuantity, setPurchaseQuantity] = useState(1);

  useEffect(() => {
    // Check if user is authenticated
    const token = localStorage.getItem('token');
    const userType = localStorage.getItem('userType');

    if (!token || userType !== 'buyer') {
      router.push('/');
      return;
    }

    if (projectId) {
      fetchProjectDetails();
    }
  }, [router, projectId]);

  const fetchProjectDetails = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await projectApi.getById(projectId);
      setProject(response.data.data);
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  const handlePurchase = () => {
    // TODO: Implement purchase flow when transaction API is ready
    alert(
      `Purchase functionality coming soon!\nYou want to buy ${purchaseQuantity} credits for ₹${(purchaseQuantity * (project?.price_per_credit || 0)).toLocaleString()}`
    );
  };

  const calculateTotal = () => {
    if (!project) return 0;
    return purchaseQuantity * project.price_per_credit;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-linear-to-br from-emerald-50 via-white to-green-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-emerald-600 border-t-transparent rounded-full animate-spin mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading project details...</p>
        </div>
      </div>
    );
  }

  if (error || !project) {
    return (
      <div className="min-h-screen bg-linear-to-br from-emerald-50 via-white to-green-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg
              className="w-10 h-10 text-red-600"
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
          </div>
          <h2 className="text-2xl font-bold text-gray-800 mb-2">
            Project Not Found
          </h2>
          <p className="text-gray-600 mb-6">
            {error || 'Unable to load project details'}
          </p>
          <button
            onClick={() => router.push('/buyer/marketplace')}
            className="px-6 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition"
          >
            Back to Marketplace
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-linear-to-br from-emerald-50 via-white to-green-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-emerald-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => router.push('/buyer/marketplace')}
              className="p-2 hover:bg-gray-100 rounded-lg transition"
            >
              <svg
                className="w-6 h-6 text-gray-600"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M15 19l-7-7 7-7"
                />
              </svg>
            </button>
            <h1 className="text-2xl font-bold bg-linear-to-r from-emerald-600 to-green-600 bg-clip-text text-transparent">
              Project Details
            </h1>
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-6">
            {/* Project Image */}
            <div className="bg-white rounded-xl shadow-lg overflow-hidden">
              <div className="h-96 bg-linear-to-br from-emerald-400 to-green-500 relative">
                {project.image_url ? (
                  <img
                    src={project.image_url}
                    alt={project.project_name}
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="w-full h-full flex items-center justify-center">
                    <svg
                      className="w-32 h-32 text-white opacity-50"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                      />
                    </svg>
                  </div>
                )}
              </div>
            </div>

            {/* Project Info */}
            <div className="bg-white rounded-xl shadow-lg p-8">
              <div className="flex items-start justify-between mb-4">
                <h2 className="text-3xl font-bold text-gray-800">
                  {project.project_name}
                </h2>
                {project.seller.is_verified && (
                  <div className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-semibold flex items-center space-x-2">
                    <svg
                      className="w-5 h-5"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                        clipRule="evenodd"
                      />
                    </svg>
                    <span>Verified Seller</span>
                  </div>
                )}
              </div>

              <div className="flex items-center text-gray-600 mb-6">
                <svg
                  className="w-5 h-5 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                  />
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
                <span className="text-lg">{project.project_location}</span>
              </div>

              <div className="prose max-w-none">
                <h3 className="text-xl font-semibold text-gray-800 mb-3">
                  About This Project
                </h3>
                <p className="text-gray-700 leading-relaxed whitespace-pre-wrap">
                  {project.project_description}
                </p>
              </div>

              <div className="mt-8 pt-6 border-t">
                <h3 className="text-xl font-semibold text-gray-800 mb-4">
                  Project Statistics
                </h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-emerald-50 rounded-lg p-4">
                    <p className="text-sm text-emerald-700 font-medium">
                      Available Credits
                    </p>
                    <p className="text-2xl font-bold text-emerald-600 mt-1">
                      {project.carbon_credits_available.toLocaleString()}
                    </p>
                  </div>
                  <div className="bg-green-50 rounded-lg p-4">
                    <p className="text-sm text-green-700 font-medium">
                      Price per Credit
                    </p>
                    <p className="text-2xl font-bold text-green-600 mt-1">
                      ₹{project.price_per_credit.toLocaleString()}
                    </p>
                  </div>
                  <div className="bg-blue-50 rounded-lg p-4">
                    <p className="text-sm text-blue-700 font-medium">Status</p>
                    <p className="text-lg font-semibold text-blue-600 mt-1 capitalize">
                      {project.project_status}
                    </p>
                  </div>
                  <div className="bg-purple-50 rounded-lg p-4">
                    <p className="text-sm text-purple-700 font-medium">
                      Listed Since
                    </p>
                    <p className="text-lg font-semibold text-purple-600 mt-1">
                      {new Date(project.created_at).toLocaleDateString()}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Seller Info */}
            <div className="bg-white rounded-xl shadow-lg p-8">
              <h3 className="text-xl font-semibold text-gray-800 mb-4">
                Seller Information
              </h3>
              <div className="space-y-3">
                <div className="flex items-center">
                  <svg
                    className="w-5 h-5 text-gray-400 mr-3"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                    />
                  </svg>
                  <span className="text-gray-700 font-medium">
                    {project.seller.organization_name}
                  </span>
                </div>
                <div className="flex items-center">
                  <svg
                    className="w-5 h-5 text-gray-400 mr-3"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                    />
                  </svg>
                  <span className="text-gray-700">
                    {project.seller.organization_email}
                  </span>
                </div>
                <div className="flex items-center">
                  <svg
                    className="w-5 h-5 text-gray-400 mr-3"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
                    />
                  </svg>
                  <span className="text-gray-700">
                    {project.seller.phone_no}
                  </span>
                </div>
              </div>
            </div>
          </div>

          {/* Sidebar - Purchase Card */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-xl shadow-lg p-6 sticky top-8">
              <h3 className="text-xl font-bold text-gray-800 mb-6">
                Purchase Credits
              </h3>

              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Quantity
                  </label>
                  <input
                    type="number"
                    min="1"
                    max={project.carbon_credits_available}
                    value={purchaseQuantity}
                    onChange={(e) =>
                      setPurchaseQuantity(
                        Math.max(
                          1,
                          Math.min(
                            project.carbon_credits_available,
                            parseInt(e.target.value) || 1
                          )
                        )
                      )
                    }
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none text-lg"
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Max: {project.carbon_credits_available.toLocaleString()}{' '}
                    credits
                  </p>
                </div>

                <div className="bg-gray-50 rounded-lg p-4 space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">Price per credit:</span>
                    <span className="font-semibold">
                      ₹{project.price_per_credit.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">Quantity:</span>
                    <span className="font-semibold">
                      {purchaseQuantity.toLocaleString()}
                    </span>
                  </div>
                  <div className="border-t pt-2 flex justify-between">
                    <span className="font-bold text-gray-800">Total:</span>
                    <span className="font-bold text-emerald-600 text-xl">
                      ₹{calculateTotal().toLocaleString()}
                    </span>
                  </div>
                </div>

                <button
                  onClick={handlePurchase}
                  className="w-full bg-linear-to-r from-emerald-600 to-green-600 text-white py-4 rounded-lg font-semibold hover:from-emerald-700 hover:to-green-700 transition-all duration-300 shadow-md hover:shadow-lg"
                >
                  Purchase Now
                </button>

                <div className="text-center">
                  <button
                    onClick={() => router.push('/buyer/marketplace')}
                    className="text-emerald-600 hover:text-emerald-700 font-medium text-sm"
                  >
                    ← Back to Marketplace
                  </button>
                </div>
              </div>

              {/* Additional Info */}
              <div className="mt-6 pt-6 border-t space-y-3">
                <div className="flex items-start space-x-2 text-sm text-gray-600">
                  <svg
                    className="w-5 h-5 text-emerald-600 shrink-0"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                  <span>Verified carbon credit projects</span>
                </div>
                <div className="flex items-start space-x-2 text-sm text-gray-600">
                  <svg
                    className="w-5 h-5 text-emerald-600 shrink-0"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                    />
                  </svg>
                  <span>Secure payment processing</span>
                </div>
                <div className="flex items-start space-x-2 text-sm text-gray-600">
                  <svg
                    className="w-5 h-5 text-emerald-600 shrink-0"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                    />
                  </svg>
                  <span>Instant certificate issuance</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
