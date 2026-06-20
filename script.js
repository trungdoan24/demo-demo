document.addEventListener("DOMContentLoaded", () => {

    console.log("Cổng thông tin nội bộ đã khởi động");

    // =====================
    // CHECK LOGIN REQUIRED PAGES
    // =====================
    function checkLoginRequiredPage() {
        const body = document.body;
        const isLoginRequired = body.classList.contains("login-required");
        const isLoggedIn = localStorage.getItem("isLoggedIn") === "true";

        if (isLoginRequired && !isLoggedIn) {
            // Redirect to login page with return URL
            const currentPage = window.location.pathname.split('/').pop() || 'index.html';
            localStorage.setItem('redirectAfterLogin', currentPage);
            alert("⚠️ Bạn cần đăng nhập để xem nội dung này!");
            window.location.href = "index.html";
            return false;
        }
        return true;
    }

    // Call this on page load
    checkLoginRequiredPage();

    // =====================
    // LOGIN STATE CHECK
    // =====================
    function updateLoginUI() {
        const isLoggedIn = localStorage.getItem("isLoggedIn") === "true";
        const loggedInUser = localStorage.getItem("loggedInUser");
        const loginBtnText = document.getElementById("loginBtnText");

        if (loginBtnText) {
            if (isLoggedIn && loggedInUser) {
                loginBtnText.innerHTML = `<i class="fa-solid fa-user"></i> ${loggedInUser} <i class="fa-solid fa-sign-out-alt"></i>`;
            } else {
                loginBtnText.textContent = "Đăng nhập";
            }
        }

        // Show/Hide "Văn bản" menu based on login status
        const vanbanMenu = document.getElementById("vanban-menu");
        if (vanbanMenu) {
            if (isLoggedIn) {
                vanbanMenu.style.display = "relative";
            } else {
                vanbanMenu.style.display = "none";
            }
        }

        // Update all protected links
        document.querySelectorAll(".protected-link").forEach(link => {
            if (isLoggedIn) {
                link.style.pointerEvents = "auto";
                link.style.opacity = "1";
            } else {
                link.style.pointerEvents = "none";
                link.style.opacity = "0.5";
            }
        });
    }

    // Check for login success message
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('login') === 'success') {
        const loggedInUser = localStorage.getItem("loggedInUser");
        if (loggedInUser) {
            console.log(`✅ Người dùng ${loggedInUser} đã đăng nhập thành công`);
        }
        // Remove login parameter from URL
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    updateLoginUI();

    // Handle logout
    const loginBtnLink = document.querySelector('a[href="index.html"]');
    if (loginBtnLink) {
        loginBtnLink.addEventListener('click', function (e) {
            const isLoggedIn = localStorage.getItem("isLoggedIn") === "true";
            if (isLoggedIn) {
                e.preventDefault();
                if (confirm("Bạn muốn đăng xuất?")) {
                    localStorage.removeItem("isLoggedIn");
                    localStorage.removeItem("loggedInUser");
                    localStorage.removeItem("loginTime");
                    updateLoginUI();
                    alert("Đã đăng xuất thành công!");
                    window.location.href = "login.html";
                }
            }
        });
    }

    // =====================
    // DARK MODE TOGGLE
    // =====================
    const darkModeBtn = document.getElementById("dark-mode-btn");
    const htmlElement = document.documentElement;

    // Load dark mode preference from localStorage
    if (localStorage.getItem("dark-mode") === "true") {
        document.body.classList.add("dark-mode");
        updateDarkModeIcon();
    }

    if (darkModeBtn) {
        darkModeBtn.addEventListener("click", () => {
            document.body.classList.toggle("dark-mode");
            const isDarkMode = document.body.classList.contains("dark-mode");
            localStorage.setItem("dark-mode", isDarkMode);
            updateDarkModeIcon();
        });
    }

    function updateDarkModeIcon() {
        const icon = darkModeBtn.querySelector("i");
        if (document.body.classList.contains("dark-mode")) {
            icon.classList.remove("fa-moon");
            icon.classList.add("fa-sun");
            darkModeBtn.title = "Chế độ sáng";
        } else {
            icon.classList.remove("fa-sun");
            icon.classList.add("fa-moon");
            darkModeBtn.title = "Chế độ tối";
        }
    }

    // =====================
    // SEARCH FUNCTIONALITY
    // =====================
    const searchBtn = document.getElementById("search-btn");
    const searchInput = document.getElementById("search-input");

    if (searchBtn && searchInput) {
        searchBtn.addEventListener("click", performSearch);
        searchInput.addEventListener("keypress", (e) => {
            if (e.key === "Enter") performSearch();
        });
    }

    function performSearch() {
        const query = searchInput.value.trim().toLowerCase();
        if (!query) {
            alert("Vui lòng nhập từ khóa tìm kiếm");
            return;
        }
        // Simple search - you can enhance this
        console.log("Searching for:", query);
        alert("Tìm kiếm: " + query);
        // Redirect to search results or filter content
    }

    // =====================
    // CARD ANIMATION
    // =====================
    document.querySelectorAll(".card").forEach(card => {
        card.addEventListener("click", () => {
            card.style.boxShadow =
                "0 0 20px rgba(212, 175, 55, .4)";

            setTimeout(() => {
                card.style.boxShadow =
                    "0 2px 10px rgba(0, 0, 0, .08)";
            }, 300);
        });
    });

    // =====================
    // HAMBURGER MENU
    // =====================
    const hamburger = document.querySelector(".hamburger");
    const menu = document.querySelector(".menu");

    if (hamburger && menu) {
        hamburger.addEventListener("click", () => {
            hamburger.classList.toggle("active");
            menu.classList.toggle("active");
        });

        // Close menu when a link is clicked
        menu.querySelectorAll("a").forEach(link => {
            link.addEventListener("click", () => {
                hamburger.classList.remove("active");
                menu.classList.remove("active");
            });
        });
    }

    // =====================
    // MEGA MENU
    // =====================
    document.querySelectorAll(".mega > a").forEach(link => {
        link.addEventListener("click", function (e) {
            if (window.innerWidth > 768) return;
            e.preventDefault();
            this.parentElement.classList.toggle("active");
        });
    });

    // =====================
    // SUBMENU LEVEL 2
    // =====================
    document.querySelectorAll(".menu-title").forEach(item => {
        item.addEventListener("click", function (e) {
            e.preventDefault();
            const currentMenu = this.nextElementSibling;

            document.querySelectorAll(".submenu-level2").forEach(menu => {
                menu.classList.remove("active");
            });

            if (currentMenu && currentMenu.classList.contains("submenu-level2")) {
                currentMenu.classList.add("active");
            }
        });
    });

    document.querySelectorAll(".submenu-item > a").forEach(link => {
        link.addEventListener("click", function (e) {
            if (window.innerWidth > 768) return;

            const submenu = this.parentElement.querySelector(".submenu-level2");
            if (!submenu) return;

            e.preventDefault();
            submenu.classList.toggle("active");
        });
    });

    // =====================
    // SMOOTH SCROLL
    // =====================
    document.querySelectorAll("a[href^='#']").forEach(anchor => {
        anchor.addEventListener("click", function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute("href"));
            if (target) {
                target.scrollIntoView({ behavior: "smooth" });
            }
        });
    });

    // =====================
    // SCROLL ANIMATIONS
    // =====================
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = "fadeIn 0.6s ease forwards";
            }
        });
    });

    document.querySelectorAll(".card").forEach(card => {
        observer.observe(card);
    });

});

// =====================
// GLOBAL FUNCTION - Check Login For Protected Documents
// =====================
function checkLoginForDocument(event) {
    const isLoggedIn = localStorage.getItem("isLoggedIn") === "true";

    if (!isLoggedIn) {
        event.preventDefault();
        event.stopPropagation();
        alert("⚠️ Bạn cần đăng nhập để xem tài liệu này!\n\nVui lòng click nút Đăng nhập ở trên để tiếp tục.");
        window.location.href = "index.html";
        return false;
    }
    return true;
}


