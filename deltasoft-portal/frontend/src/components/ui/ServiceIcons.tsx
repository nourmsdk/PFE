type IconProps = { size?: number };

export function InboxIcon({ size = 26 }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path
        d="M3 12.5 5.2 5.6A2 2 0 0 1 7.1 4.2h9.8a2 2 0 0 1 1.9 1.4L21 12.5"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M3 12.5h5.1a1 1 0 0 1 .93.63l.6 1.5a1 1 0 0 0 .93.62h3a1 1 0 0 0 .93-.62l.6-1.5a1 1 0 0 1 .93-.63H21V18a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-5.5Z"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function WrenchIcon({ size = 26 }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path
        d="M14.7 6.3a4 4 0 0 0-5.4 4.9L4 16.5V20h3.5l5.3-5.3a4 4 0 0 0 4.9-5.4l-2.6 2.6-2.1-.7-.7-2.1 2.4-2.4Z"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function ShieldCheckIcon({ size = 26 }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" aria-hidden="true">
      <path
        d="M12 3.5 19 6v5.2c0 4.2-2.9 7.7-7 8.8-4.1-1.1-7-4.6-7-8.8V6l7-2.5Z"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinejoin="round"
      />
      <path
        d="m9 12.3 2 2 4-4.2"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}
