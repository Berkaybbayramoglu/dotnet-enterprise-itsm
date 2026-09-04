const http = require('node:http');

const options = {
  hostname: 'localhost',
  port: 5246,
  path: '/api/Test/roles',
  method: 'GET',
};

const req = http.request(options, res => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => console.log(data));
});

req.on('error', error => console.error(error));
req.end();
