const fetch = require('node-fetch');
async function test() {
    const res = await fetch('http://127.0.0.1:5246/api/Ticket/2/attachments', {
        headers: { 'Authorization': 'Bearer ' + 'dummy_token' } // wait, I don't have a token.
    });
    console.log(res.status);
}
test();
