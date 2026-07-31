import { Bar, BarChart, CartesianGrid, LabelList, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { STATUS, CHART_INK } from "./chartTheme";

export function CategoryBarChart({ data }: { data: { category: string; count: number }[] }) {
  return (
    <ResponsiveContainer width="100%" height={200}>
      <BarChart data={data} layout="vertical" margin={{ top: 8, right: 24, left: 0, bottom: 0 }}>
        <CartesianGrid horizontal={false} stroke={CHART_INK.grid} />
        <XAxis type="number" allowDecimals={false} tick={{ fill: CHART_INK.muted, fontSize: 12 }} axisLine={false} tickLine={false} />
        <YAxis
          type="category"
          dataKey="category"
          tick={{ fill: CHART_INK.secondary, fontSize: 12 }}
          axisLine={false}
          tickLine={false}
          width={90}
        />
        <Tooltip
          cursor={{ fill: "rgba(0,0,0,0.04)" }}
          contentStyle={{ borderRadius: 8, borderColor: CHART_INK.grid, fontSize: 13 }}
        />
        <Bar dataKey="count" fill={STATUS.critical} radius={[0, 4, 4, 0]} maxBarSize={22}>
          <LabelList dataKey="count" position="right" fill={CHART_INK.secondary} fontSize={12} fontWeight={700} />
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}
