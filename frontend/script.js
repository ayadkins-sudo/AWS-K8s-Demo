async function checkAPI() {
  try {
    const res = await fetch('/api/info');
    const data = await res.json();
    document.getElementById('api-output').textContent =
      JSON.stringify(data, null, 2);
  } catch (err) {
    document.getElementById('api-output').textContent =
      "API request failed";
  }
}