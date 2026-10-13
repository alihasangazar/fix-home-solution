export type Service = { id: string; name: string; ur: string; icon: string; description: string; descriptionUr: string; };
export type Booking = {
  id: string; user_id?: string | null; customer_name: string; phone: string;
  service_name: string; booking_date: string; booking_time: string;
  address: string; notes: string; status: "pending" | "confirmed" | "in_progress" | "completed" | "cancelled";
  created_at: string;
};
