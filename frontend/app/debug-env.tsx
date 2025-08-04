'use client';

export default function DebugEnv() {
  return (
    <div className="fixed bottom-4 right-4 bg-black text-white p-4 rounded-lg text-xs max-w-md z-50">
      <h3 className="font-bold mb-2">Environment Variables Debug:</h3>
      <div className="space-y-1">
        <div><strong>NEXT_PUBLIC_API_URL:</strong> {process.env.NEXT_PUBLIC_API_URL || 'NOT SET'}</div>
        <div><strong>NODE_ENV:</strong> {process.env.NODE_ENV || 'NOT SET'}</div>
        <div><strong>PORT:</strong> {process.env.PORT || 'NOT SET'}</div>
      </div>
    </div>
  );
} 