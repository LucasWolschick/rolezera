// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js");
}

function base64Encode(buffer) {
  return btoa(
    String.fromCharCode(...new Uint8Array(buffer))
  );
}

async function subscribeToPush() {
  if (!("PushManager" in window)) return;

  const registration = await navigator.serviceWorker.ready;
  const existing = await registration.pushManager.getSubscription();
  if (existing) return;

  const permission = await Notification.requestPermission();
  if (permission !== "granted") return;

  const key = document.querySelector(
    'meta[name="vapid-public-key"]'
  ).content;

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: key,
  });

  await fetch("/push_subscriptions", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      push_subscription: {
        endpoint: subscription.endpoint,
        auth_key: base64Encode(subscription.getKey("auth")),
        p256dh_key: base64Encode(subscription.getKey("p256dh"))
      }
    }),
  });
}

document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("enable-push");
  if (!btn) return;

  btn.style.display = "block";

  btn.addEventListener("click", () => {
    subscribeToPush();
    btn.remove();
  });
});