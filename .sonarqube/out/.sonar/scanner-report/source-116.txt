const token = localStorage.getItem('jwt_token');
const payload = JSON.parse(atob(token.split('.')[1]));
console.log(payload);
