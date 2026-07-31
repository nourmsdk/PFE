type IconProps = { size?: number };

export function ChatIcon({ size = 20 }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path
        d="M4 5.5h16v10.5H8.8L5 19.5V16H4V5.5Z"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinejoin="round"
      />
      <path d="M8 9.5h8M8 12.5h5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
    </svg>
  );
}

export function ChartIcon({ size = 20 }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path d="M4 20V4" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
      <path d="M4 20h16" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
      <rect x="7" y="13" width="2.6" height="5" rx="0.6" fill="currentColor" />
      <rect x="12" y="9" width="2.6" height="9" rx="0.6" fill="currentColor" />
      <rect x="17" y="6" width="2.6" height="12" rx="0.6" fill="currentColor" />
    </svg>
  );
}

export function SparkleIcon({ size = 20 }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path
        d="M12 3.5c.5 2.7 1.4 4.4 3 5.5 1.6 1.1 3.4 1.3 3.5 1.5-.1.2-1.9.4-3.5 1.5-1.6 1.1-2.5 2.8-3 5.5-.5-2.7-1.4-4.4-3-5.5-1.6-1.1-3.4-1.3-3.5-1.5.1-.2 1.9-.4 3.5-1.5 1.6-1.1 2.5-2.8 3-5.5Z"
        stroke="currentColor"
        strokeWidth="1.6"
        strokeLinejoin="round"
      />
    </svg>
  );
}
