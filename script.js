// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Button click event handler
const ctaButton = document.getElementById('cta-button');
const buttonMessage = document.getElementById('button-message');

ctaButton.addEventListener('click', function() {
    // Add animation to button
    ctaButton.style.transform = 'scale(0.95)';
    setTimeout(() => {
        ctaButton.style.transform = '';
    }, 150);

    // Show message
    const messages = [
        "Thanks for your interest! Feel free to reach out via email or phone.",
        "Let's connect and discuss how we can work together!",
        "I'd love to hear from you! Check out my contact details below.",
        "Ready to collaborate? Get in touch through the contact section!"
    ];
    
    const randomMessage = messages[Math.floor(Math.random() * messages.length)];
    
    buttonMessage.textContent = randomMessage;
    buttonMessage.classList.add('show');
    buttonMessage.style.opacity = '1';
    
    // Scroll to contact section
    setTimeout(() => {
        document.getElementById('contact').scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }, 500);

    // Fade out message after 5 seconds
    setTimeout(() => {
        buttonMessage.style.opacity = '0';
        setTimeout(() => {
            buttonMessage.textContent = '';
            buttonMessage.classList.remove('show');
        }, 300);
    }, 5000);
});

// Add scroll animation to sections
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all sections for scroll animations
document.querySelectorAll('section').forEach(section => {
    section.style.opacity = '0';
    section.style.transform = 'translateY(20px)';
    section.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(section);
});

// Make hero section visible immediately
const heroSection = document.querySelector('.hero');
if (heroSection) {
    heroSection.style.opacity = '1';
    heroSection.style.transform = 'translateY(0)';
}

// Add hover effect to project cards
document.querySelectorAll('.project-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-10px) scale(1.02)';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0) scale(1)';
    });
});

// Add click effect to contact items
document.querySelectorAll('.contact-item').forEach(item => {
    item.addEventListener('click', function() {
        const text = this.querySelector('p').textContent;
        
        // Copy to clipboard if it's email or phone
        if (text.includes('@') || text.includes('+')) {
            navigator.clipboard.writeText(text).then(() => {
                const originalText = this.querySelector('p').textContent;
                this.querySelector('p').textContent = 'Copied to clipboard!';
                this.querySelector('p').style.color = 'var(--primary-color)';
                
                setTimeout(() => {
                    this.querySelector('p').textContent = originalText;
                    this.querySelector('p').style.color = '';
                }, 2000);
            }).catch(err => {
                console.log('Failed to copy:', err);
            });
        }
    });
    
    item.style.cursor = 'pointer';
});

// Navbar background on scroll
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    const isDarkMode = document.body.classList.contains('dark-mode');
    
    if (window.scrollY > 50) {
        if (isDarkMode) {
            navbar.style.backgroundColor = 'rgba(17, 24, 39, 0.95)';
        } else {
            navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
        }
        navbar.style.backdropFilter = 'blur(10px)';
    } else {
        navbar.style.backgroundColor = 'var(--bg-white)';
        navbar.style.backdropFilter = 'none';
    }
});

// Dark Mode Toggle Functionality
const darkModeToggle = document.getElementById('dark-mode-toggle');
const body = document.body;

// Check for saved theme preference or default to light mode
const currentTheme = localStorage.getItem('theme') || 'light';

// Apply the saved theme on page load
if (currentTheme === 'dark') {
    body.classList.add('dark-mode');
}

// Function to toggle dark mode
function toggleDarkMode() {
    body.classList.toggle('dark-mode');
    
    // Save the current theme to localStorage
    const isDarkMode = body.classList.contains('dark-mode');
    localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');
    
    // Update navbar background on scroll if needed
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        if (isDarkMode) {
            navbar.style.backgroundColor = 'rgba(17, 24, 39, 0.95)';
        } else {
            navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
        }
    }
}

// Add click event listener to the toggle button
if (darkModeToggle) {
    darkModeToggle.addEventListener('click', toggleDarkMode);
    
    // Add keyboard accessibility (Enter and Space keys)
    darkModeToggle.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            toggleDarkMode();
        }
    });
}

