document.addEventListener("DOMContentLoaded", () => {

    console.log("Cổng thông tin nội bộ đã khởi động");

    /* Hiệu ứng card */

    document.querySelectorAll(".card").forEach(card => {

        card.addEventListener("click", () => {

            card.style.boxShadow =
                "0 0 20px rgba(0,102,204,.4)";

            setTimeout(() => {

                card.style.boxShadow =
                    "0 2px 10px rgba(0,0,0,.08)";

            }, 300);

        });

    });

    /* Hamburger */

    const hamburger =
        document.querySelector(".hamburger");

    const menu =
        document.querySelector(".menu");

    if (hamburger && menu) {

        hamburger.addEventListener("click", () => {

            hamburger.classList.toggle("active");
            menu.classList.toggle("active");

        });

    }

    /* Mega menu */

    document.querySelectorAll(".mega > a")
        .forEach(link => {

            link.addEventListener("click", function (e) {

                if (window.innerWidth > 768) return;

                e.preventDefault();

                const parent = this.parentElement;

                document
                    .querySelectorAll(".mega")
                    .forEach(item => {

                        if (item !== parent) {
                            item.classList.remove("active");
                        }

                    });

                parent.classList.toggle("active");

            });

        });

    /* Menu cấp 2 */

    document.querySelectorAll(".submenu-item > a")
        .forEach(link => {

            link.addEventListener("click", function (e) {

                if (window.innerWidth > 768) return;

                const submenu =
                    this.parentElement.querySelector(
                        ".submenu-level2"
                    );

                if (!submenu) return;

                e.preventDefault();

                document
                    .querySelectorAll(".submenu-level2")
                    .forEach(item => {

                        if (item !== submenu) {
                            item.style.display = "none";
                        }

                    });

                submenu.style.display =
                    submenu.style.display === "block"
                        ? "none"
                        : "block";

            });

        });

    /* Resize */

    window.addEventListener("resize", () => {

        if (window.innerWidth > 768) {

            menu?.classList.remove("active");
            hamburger?.classList.remove("active");

            document
                .querySelectorAll(".mega")
                .forEach(item => {
                    item.classList.remove("active");
                });

            document
                .querySelectorAll(".submenu-level2")
                .forEach(item => {
                    item.style.display = "";
                });

        }

    });

});
