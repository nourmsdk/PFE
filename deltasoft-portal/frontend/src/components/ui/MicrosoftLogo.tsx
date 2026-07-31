export function MicrosoftLogo({ size = 32 }: { size?: number }) {
  const gap = size * 0.06;
  const square = (size - gap) / 2;

  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} aria-hidden="true">
      <rect x={0} y={0} width={square} height={square} fill="#F25022" />
      <rect x={square + gap} y={0} width={square} height={square} fill="#7FBA00" />
      <rect x={0} y={square + gap} width={square} height={square} fill="#00A4EF" />
      <rect x={square + gap} y={square + gap} width={square} height={square} fill="#FFB900" />
    </svg>
  );
}
