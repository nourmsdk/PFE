export function FacebookIcon({ size = 18 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M13.5 22v-8.5H16l.4-3H13.5V8.5c0-.87.24-1.46 1.5-1.46H16.5V4.35C16.2 4.31 15.19 4.22 14 4.22c-2.4 0-4 1.46-4 4.14V10.5H7.5v3H10V22h3.5Z" />
    </svg>
  );
}

export function LinkedInIcon({ size = 18 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M6.94 8.5H3.56V20h3.38V8.5ZM5.25 3.5a1.96 1.96 0 1 0 0 3.92 1.96 1.96 0 0 0 0-3.92ZM20.44 20h-3.37v-6.05c0-1.44-.03-3.3-2.01-3.3-2.01 0-2.32 1.57-2.32 3.2V20H9.38V8.5h3.24v1.57h.05c.45-.86 1.56-1.77 3.21-1.77 3.43 0 4.06 2.26 4.06 5.2V20Z" />
    </svg>
  );
}
