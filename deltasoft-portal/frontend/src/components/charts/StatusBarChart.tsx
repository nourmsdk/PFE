import { Bar, BarChart, CartesianGrid, Cell, LabelList, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { SEQUENTIAL_BLUE, CHART_INK } from "./chartTheme";

const STATUS_COLORS: Record<string, string> = {
  Nouvelle: SEQUENTIAL_BLUE.step250,
  "En cours": SEQUENTIAL_BLUE.step400,
  Résolue: SEQUENTIAL_BLUE.step550,
  Clôturée: SEQUENTIAL_BLUE.step700,
};

export function StatusBarChart({ data }: { data: { status: string; count: number }[] }) {
  return (
    <ResponsiveContainer width="100%" height={220}>
      <BarChart data={data} margin={{ top: 16, right: 8, left: -16, bottom: 0 }}>
        <CartesianGrid vertical={false} stroke={CHART_INK.grid} />
        <XAxis
          dataKey="status"
          tick={{ fill: CHART_INK.secondary, fontSize: 12 }}
          axisLine={{ stroke: CHART_INK.grid }}
          tickLine={false}
        />
        <YAxis
          allowDecimals={false}
          tick={{ fill: CHART_INK.muted, fontSize: 12 }}
          axisLine={false}
          tickLine={false}
          width={28}
        />
        <Tooltip
          cursor={{ fill: "rgba(0,0,0,0.04)" }}
          contentStyle={{ borderRadius: 8, borderColor: CHART_INK.grid, fontSize: 13 }}
        />
        <Bar dataKey="count" radius={[4, 4, 0, 0]} maxBarSize={28}>
          {data.map((entry) => (
            <Cell key={entry.status} fill={STATUS_COLORS[entry.status] ?? SEQUENTIAL_BLUE.step400} />
          ))}
          <LabelList dataKey="count" position="top" fill={CHART_INK.secondary} fontSize={12} fontWeight={700} />
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}
