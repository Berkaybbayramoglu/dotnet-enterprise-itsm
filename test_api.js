const http = require('http');

const options = {
  hostname: 'localhost',
  port: 5246,
  path: '/api/Roles',
  method: 'GET',
  headers: {
    'Authorization': 'Bearer admin_token_here' // Maybe the API doesn't need auth? Wait, it needs it.
  }
};

const req = http.request(options, res => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => console.log('Response:', res.statusCode, data));
});
req.end();
