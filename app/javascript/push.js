if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js");
}

function base64Encode(buffer) {
  return btoa(
    String.fromCharCode(...new Uint8Array(buffer))
  );
}

async function subscribeAndSendToServer(registration) {
  const vapidKey = document.querySelector('meta[name="vapid-public-key"]').content;

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: vapidKey,
  });

  await fetch("/push_subscriptions", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      push_subscription: {
        endpoint: subscription.endpoint,
        auth_key: base64Encode(subscription.getKey("auth")),
        p256dh_key: base64Encode(subscription.getKey("p256dh")),
      }
    })
  });
}

async function reconcilePushSubscription() {
  const registration = await navigator.serviceWorker.ready;
  const localSub = await registration.pushManager.getSubscription();

  // CASE 1: no local subscription → subscribe
  if (!localSub) {
    await subscribeAndSendToServer(registration);
    return;
  }

  // Ask server if it knows this subscription
  const response = await fetch("/push_subscriptions", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ probe: true, endpoint: localSub.endpoint })
  });

  // CASE 4: local + server → do nothing
  if (response.status === 204) return;

  // CASE 2 & 3: mismatch → reset + resubscribe
  await localSub.unsubscribe();
  await subscribeAndSendToServer(registration);
}

document.addEventListener("DOMContentLoaded", async () => {
  if (sessionStorage.getItem("push-cta-dismissed")) return;

  const reg = await navigator.serviceWorker.ready;
  const sub = await reg.pushManager.getSubscription();

  const res = await fetch("/push_subscriptions/status", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ endpoint: sub?.endpoint })
  });

  if (res.status !== 404) return;

  const frame = document.getElementById("bottom_sheet");
  frame.src = "/push_subscriptions/cta";

  const controller = document.querySelector('[data-controller="sheet"]').sheetController;
  controller.dismissibleValue = false;
  controller.open();
});

document.addEventListener("click", async e => {
  if (!e.target.matches("#enable-push")) return;

  const permission = await Notification.requestPermission();
  if (permission !== "granted") return;

  await reconcilePushSubscription();
  document.querySelector('[data-controller="sheet"]').sheetController.close();
});