const express = require('express');
const app = express();

app.use("/", (req, res) => {
    res.send(
        "test"
    )
})

app.listen(8000, () => {
    console.log("Listening")
})