'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { projectApi, handleApiError } from '@/lib/api';

export default function CreateProjectPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [formData, setFormData] = useState({
    project_name: '',
    project_description: '',
    project_location: '',
    carbon_credits_available: '',
    price_per_credit: '',
    image_url: '',
  });

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const projectData = {
        project_name: formData.project_name,
        project_description: formData.project_description,
        project_location: formData.project_location,
        carbon_credits_available: parseFloat(formData.carbon_credits_available),
        price_per_credit: parseFloat(formData.price_per_credit),
        image_url: formData.image_url || undefined,
        project_status: 'active',
      };

      await projectApi.create(projectData);
      router.push('/seller/dashboard');
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-linear-to-br from-emerald-50 via-white to-green-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-emerald-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => router.push('/seller/dashboard')}
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
              Create New Project
            </h1>
          </div>
        </div>
      </header>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white rounded-xl shadow-lg border border-emerald-100 p-8">
          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Project Name */}
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Project Name *
              </label>
              <input
                type="text"
                name="project_name"
                required
                value={formData.project_name}
                onChange={handleChange}
                placeholder="e.g., Amazon Rainforest Conservation"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none transition"
              />
            </div>

            {/* Project Description */}
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Project Description *
              </label>
              <textarea
                name="project_description"
                required
                value={formData.project_description}
                onChange={handleChange}
                rows={6}
                placeholder="Describe your carbon credit project, its impact, methodology, and key features..."
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none transition resize-none"
              />
            </div>

            {/* Project Location */}
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Project Location *
              </label>
              <input
                type="text"
                name="project_location"
                required
                value={formData.project_location}
                onChange={handleChange}
                placeholder="e.g., Amazon Basin, Brazil"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none transition"
              />
            </div>

            {/* Credits and Price */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Carbon Credits Available *
                </label>
                <input
                  type="number"
                  name="carbon_credits_available"
                  required
                  min="1"
                  step="1"
                  value={formData.carbon_credits_available}
                  onChange={handleChange}
                  placeholder="1000"
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none transition"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Number of carbon credits to list
                </p>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Price per Credit (₹) *
                </label>
                <input
                  type="number"
                  name="price_per_credit"
                  required
                  min="0"
                  step="0.01"
                  value={formData.price_per_credit}
                  onChange={handleChange}
                  placeholder="500"
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none transition"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Price in Indian Rupees
                </p>
              </div>
            </div>

            {/* Image URL (Optional) */}
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Project Image URL (Optional)
              </label>
              <input
                type="url"
                name="image_url"
                value={formData.image_url}
                onChange={handleChange}
                placeholder="https://example.com/project-image.jpg"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 outline-none transition"
              />
              <p className="text-xs text-gray-500 mt-1">
                Add a URL to an image representing your project
              </p>
            </div>

            {/* Summary Card */}
            <div className="bg-emerald-50 rounded-lg p-6 border border-emerald-200">
              <h3 className="font-semibold text-gray-800 mb-4">
                Project Summary
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600">Total Credits:</span>
                  <span className="font-semibold">
                    {formData.carbon_credits_available || '0'} credits
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Price per Credit:</span>
                  <span className="font-semibold">
                    ₹{formData.price_per_credit || '0'}
                  </span>
                </div>
                <div className="flex justify-between border-t pt-2 mt-2">
                  <span className="text-gray-800 font-semibold">
                    Potential Revenue:
                  </span>
                  <span className="font-bold text-emerald-600 text-lg">
                    ₹
                    {(
                      parseFloat(formData.carbon_credits_available || '0') *
                      parseFloat(formData.price_per_credit || '0')
                    ).toLocaleString()}
                  </span>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex items-center justify-end space-x-4 pt-6 border-t">
              <button
                type="button"
                onClick={() => router.push('/seller/dashboard')}
                className="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition font-medium"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={loading}
                className="px-8 py-3 bg-linear-to-r from-emerald-600 to-green-600 text-white rounded-lg font-semibold hover:from-emerald-700 hover:to-green-700 transition-all duration-300 shadow-md hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <span className="flex items-center">
                    <svg
                      className="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                      ></circle>
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      ></path>
                    </svg>
                    Creating...
                  </span>
                ) : (
                  'Create Project'
                )}
              </button>
            </div>
          </form>
        </div>

        {/* Info Section */}
        <div className="mt-8 bg-blue-50 rounded-xl p-6 border border-blue-200">
          <div className="flex items-start space-x-3">
            <svg
              className="w-6 h-6 text-blue-600 shrink-0 mt-0.5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <div>
              <h4 className="font-semibold text-blue-900 mb-2">
                Project Guidelines
              </h4>
              <ul className="text-sm text-blue-800 space-y-1 list-disc list-inside">
                <li>
                  Ensure your project follows international carbon credit
                  standards
                </li>
                <li>Provide accurate and verifiable information</li>
                <li>Include high-quality images when possible</li>
                <li>Set competitive pricing based on market rates</li>
                <li>Your project will be reviewed before going live</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
