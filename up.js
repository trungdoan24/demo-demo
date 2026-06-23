const fs = require("fs-extra");
const path = require("path");

const ROOT = path.join(__dirname, "sohoa");
const OUT = path.join(__dirname, "dist");

// map category -> file list
let categories = {};

function walk(dir, relativePath = "") {
    const items = fs.readdirSync(dir);

    for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            walk(fullPath, path.join(relativePath, item));
        } else if (item.endsWith(".pdf")) {
            const category = relativePath.split(path.sep)[0] || "root";

            if (!categories[category]) categories[category] = [];

            categories[category].push({
                name: item,
                path: path.relative(OUT, fullPath).replace(/\\/g, "/")
            });
        }
    }
}

function buildHtmlFile(name, files) {
    return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${name}</title>
</head>
<body>
  <h1>Thư mục: ${name}</h1>
  <ul>
    ${files.map(f => `<li><a href="../sohoa/${f.path}">${f.name}</a></li>`).join("\n")}
  </ul>
  <a href="index.html">⬅ Trang chính</a>
</body>
</html>
`;
}

function buildIndex() {
    const links = Object.keys(categories)
        .map(c => `<li><a href="${c}.html">${c}</a></li>`)
        .join("\n");

    return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>So hóa</title>
</head>
<body>
  <h1>Danh mục tài liệu</h1>
  <ul>
    ${links}
  </ul>
</body>
</html>
`;
}

function build() {
    categories = {};

    walk(ROOT);

    fs.ensureDirSync(OUT);

    // index
    fs.writeFileSync(path.join(OUT, "index.html"), buildIndex());

    // từng category
    for (const [cat, files] of Object.entries(categories)) {
        fs.writeFileSync(
            path.join(OUT, `${cat}.html`),
            buildHtmlFile(cat, files)
        );
    }

    console.log("✔ Đã quét xong thư mục và cập nhật HTML");
}

build();