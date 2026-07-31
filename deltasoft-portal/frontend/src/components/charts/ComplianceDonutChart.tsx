import { Cell, Legend, Pie, PieChart, ResponsiveContainer, Tooltip } from "recharts";
import { STATUS, CHART_INK } from "./chartTheme";

const COLORS: Record<string, string> = {
  Conforme: STATUS.good,
  "Non conforme": STATUS.critical,
  "À contrôler": STATUS.neutral,
};

export function ComplianceDonutChart({ data }: { data: { label: string; value: number }[] }) {
  const total = data.reduce((sum, d) => sum + d.value, 0);

  return (
    <ResponsiveContainer width="100%" height={220}>
      <PieChart>
        <Pie
          data={data}
          dataKey="value"
          nameKey="label"
          innerRadius={55}
          outerRadius={80}
          paddingAngle={2}
          cornerRadius={4}
          stroke="var(--white)"
          strokeWidth={2}
        >
          {data.map((entry) => (
            <Cell key={entry.label} fill={COLORS[entry.label] ?? STATUS.neutral} />
          ))}
        </Pie>
        <Tooltip
          contentStyle={{ borderRadius: 8, borderColor: CHART_INK.grid, fontSize: 13 }}
          formatter={(value, name) => [
            `${value} (${total ? Math.round((Number(value) / total) * 100) : 0}%)`,
            name,
          ]}
        />
        <Legend
          verticalAlign="bottom"
          height={36}
          iconType="circle"
          iconSize={8}
          formatter={(value) => <span style={{ color: CHART_INK.secondary, fontSize: 12 }}>{value}</span>}
        />
      </PieChart>
    </ResponsiveContainer>
  );
}
