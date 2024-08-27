const express = require('express');
const path = require('path');

const app = express();

// Set the view engine to ejs
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Home route
app.get('/', (req, res) => {
    res.render('index', { title: 'Home' });
});

// About route
app.get('/about', (req, res) => {
    res.render('about', { title: 'About' });
});

// 404 Error route
app.use((req, res) => {
    res.status(404).render('error', { title: '404 - Not Found' });
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
