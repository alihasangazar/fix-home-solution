import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = {
  title: "Fix Home Solution | Home Services",
  description: "Book trusted home services in Bahawalpur and nearby areas.",
};
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
