document.addEventListener("DOMContentLoaded", () => {
  const startTimeSelect = document.querySelector(
    "#user_availability_start_time"
  );
  const endTimeSelect = document.querySelector("#user_availability_end_time");

  if (startTimeSelect && endTimeSelect) {
    startTimeSelect.addEventListener("change", () => {
      const startTime = new Date(`1970-01-01T${startTimeSelect.value}:00`);
      const endTime = new Date(startTime.getTime() + 30 * 60 * 1000); // Add 30 minutes

      const hours = endTime.getHours().toString().padStart(2, "0");
      const minutes = endTime.getMinutes().toString().padStart(2, "0");

      endTimeSelect.value = `${hours}:${minutes}`;
    });
  }
});
