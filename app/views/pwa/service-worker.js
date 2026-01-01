// Add a service worker for processing Web Push notifications:

self.addEventListener("push", async (event) => {
  const { title, options } = await event.data.json()
  event.waitUntil(self.registration.showNotification(title, options))
})

self.addEventListener("notificationclick", function(event) {
  event.notification.close()
  
  const url = event.notification.data?.url;
  if (!url) return;

  event.waitUntil(
    clients.openWindow(url)
  );
})
