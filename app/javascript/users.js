window.addEventListener('turbo:load', () => {
  const tokenButton = document.getElementById('token-button');
  if (!tokenButton) return;

  tokenButton.addEventListener('click', (event) => {
    event.preventDefault();
    document.getElementById('user_calendar_access_token').value = '';
  });
});
