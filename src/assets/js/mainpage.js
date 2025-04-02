main()
async function main() {
    let res = await fetch("https://raw.githubusercontent.com/MoonLGH/templateTailwind/main/package.json")
    res = await res.json()
    res = res.dependencies

    for (var key in res) {
        if (res.hasOwnProperty(key)) {
            console.log(key + " -> " + res[key]);
            document.querySelector("#Deps").innerHTML += `<span>${key} Version ${res[key]}</span><br>`
        }
    }
}