const fs = require("fs");
const path = require("path");

const ignoreDirs = [
  "node_modules",
  ".react-router",
  ".git",
  "dist",
  "build",
  "dev-dist",
  "public",
  "tests",
  "temp",
  ".vscode",
  "log",
  "storage",
  "vendor",
  "tmp",
];

const ignoreFiles = [
  "yarn.lock",
  "package-lock.json",
  "dump-files.cjs",
  "README.md",
  ".gitignore",
  ".env",
  ".env.example",
  ".vscode",
  ".keep",
  ".gitattributes",
];

function getAllFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir); // lista tudo dentro da pasta "dir"

  files.forEach((file) => {
    const filepath = path.join(dir, file); // monta caminho completo
    const stat = fs.statSync(filepath); // pega informações (arquivo ou pasta)

    if (stat.isDirectory()) {
      if (!ignoreDirs.includes(file)) {
        // se for pasta e não está na blacklist
        getAllFiles(filepath, fileList); // chama a função de novo (recursão)
      }
    } else {
      if (!ignoreFiles.includes(file)) {
        // se for arquivo e não está na blacklist
        fileList.push(filepath); // adiciona à lista
      }
    }
  });

  return fileList;
}
const allFiles = getAllFiles(process.cwd()); // process.cwd() pega o diretório atual de onde você rodou o script.
const outFile = "Cart.txt";

const stream = fs.createWriteStream(outFile);

allFiles.forEach((file) => {
  const relativePath = path.relative(process.cwd(), file).replace(/\\/g, "/");
  const content = fs.readFileSync(file, "utf-8"); // sincronismo, roda tudo em ordem

  stream.write(`arquivo ${relativePath}\n`); // escreve o caminho
  stream.write(content); // escreve o conteúdo
  stream.write("\n\n\n");
});

stream.end(() => console.log(`Dump finalizado em ${outFile}`));
