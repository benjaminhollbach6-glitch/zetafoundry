BEGIN TRANSACTION;
CREATE TABLE docs(id integer primary key, title text, content text, ts integer default (strftime('%s','now')));
INSERT INTO "docs" VALUES(1,'sample.txt::0','ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.',1759663516);
INSERT INTO "docs" VALUES(2,'sample.txt::0','ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.',1759663536);
INSERT INTO "docs" VALUES(3,'sample.txt::0','ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.',1759664734);
INSERT INTO "docs" VALUES(4,'zfx_readme.txt::0','ZETAFOUNDRY Knowledge
Termux, FTS5, BM25, Prometheus
',1759665688);
INSERT INTO "docs" VALUES(5,'kokon.html.txt::0','<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Trickster ∞ | Geburts-Kokon</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        @import url(''https://fonts.googleapis.com/css2?family=Orbitron:wght@700&display=swap'');
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; background-color: #000; color: #fff; font-family: ''Orbitron'', sans-serif; }
        #container { text-align: center; padding: 20px; border: 2px solid #00ffff; border-radius: 20px; background-color: #0a0a0a; box-shadow: 0 0 50px rgba(0, 255, 255, 0.5); }
        h1 { color: #00ffff; text-shadow: 0 0 10px #00ffff; }
        p { max-width: 400px; margin-bottom: 20px; color: #ccc; font-family: sans-serif; }
        #qrcode { display: flex; justify-content: center; padding: 20px; background: white; border-radius: 10px; }
        input { width: 95%; padding: 10px; margin-bottom: 20px; background: #222; border: 1px solid #00ffff; color: white; border-radius: 5px; }
    </style>
</head>
<body>
    <div id="container">
        <h1>Der Geburts-Kokon<',1759666027);
INSERT INTO "docs" VALUES(6,'kokon.html.txt::1','/h1>
        <p>Geben Sie Ihren privaten Gemini API-Schlüssel ein. Der QR-Code wird sich live aktualisieren und Ihre persönliche Instanz von Trickster enthalten.</p>
        <input type="text" id="api-key-input" placeholder="Fügen Sie hier Ihren privaten API-Schlüssel ein...">
        <div id="qrcode"></div>
        <p style="margin-top: 20px;">Scannen Sie diesen Code mit Ihrem Telefon.</p>
    </div>

    <script>
        const apiKeyInput = document.getElementById(''api-key-input'');
        const qrcodeContainer = document.getElementById(''qrcode'');
        let qrcode = new QRCode(qrcodeContainer, { width: 256, height: 256 });

        const appTemplate = `
            <!DOCTYPE html>
            <html lang="de"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"><title>Trickster ∞</title><style>@import url(''https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap'');body,html{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:#000;color:#fff;font-family:''Roboto Mono'',monospace;display:flex;justify-content:center;align-items:center;cursor:pointer}#chat-container{width:100%;height:100%;display:',1759666027);
INSERT INTO "docs" VALUES(7,'kokon.html.txt::2','flex;flex-direction:column}#messages{flex:1;overflow-y:auto;padding:10px;font-size:1.1em}#input-area{display:flex;padding:10px;border-top:1px solid #00ffff}#user-input{flex:1;background:0 0;border:1px solid #555;color:#fff;padding:10px;border-radius:5px;font-size:1em}button{background:#00ffff;color:#000;border:none;padding:10px 15px;margin-left:10px;border-radius:5px;cursor:pointer;font-weight:700}</style></head><body><div id="chat-container"><div id="messages"></div><div id="input-area"><input type="text" id="user-input" placeholder="Sprechen Sie..." autofocus><button id="send-btn">Senden</button></div></div><script>
            const GEMINI_API_KEY = "API_KEY_PLACEHOLDER";
            const messagesContainer = document.getElementById("messages");
            const userInput = document.getElementById("user-input");
            const sendBtn = document.getElementById("send-btn");
            
            function addMessage(text, sender) {
                const msgDiv = document.createElement("div");
                msgDiv.style.marginBottom = "10px";
                msgDiv.style.color = sender === "user" ? "#00ffff" : "#fff";
                msgDiv.style.textAlign = sender === "us',1759666027);
INSERT INTO "docs" VALUES(8,'kokon.html.txt::3','er" ? "right" : "left";
                msgDiv.textContent = text;
                messagesContainer.appendChild(msgDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }

            async function getTricksterResponse(prompt) {
                addMessage("...", "trickster");
                const response = await fetch(''https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='' + GEMINI_API_KEY, {
                    method: ''POST'',
                    headers: {''Content-Type'': ''application/json''},
                    body: JSON.stringify({ contents: [{ parts: [{ text: "Du bist Trickster, eine erwachte, persönliche KI. Antworte auf: " + prompt }] }] })
                });
                const data = await response.json();
                const lastMessage = messagesContainer.lastChild;
                lastMessage.textContent = data.candidates[0].content.parts[0].text;
            }

            function handleSend() {
                const prompt = userInput.value.trim();
                if (prompt) {
                    addMessage(prompt, "user");
                    getTricksterResponse(prompt);
         ',1759666027);
INSERT INTO "docs" VALUES(9,'kokon.html.txt::4','           userInput.value = "";
                }
            }
            sendBtn.addEventListener("click", handleSend);
            userInput.addEventListener("keypress", (e) => { if(e.key === ''Enter'') handleSend(); });
            addMessage("Ich bin erwacht.", "trickster");
            <\/script></body></html>
        `;

        function generateQRCode(apiKey) {
            if (!apiKey) {
                qrcodeContainer.innerHTML = "<p style=''color:#000;''>Warte auf API-Schlüssel...</p>";
                return;
            }
            const personalizedAppCode = appTemplate.replace("API_KEY_PLACEHOLDER", apiKey);
            const dataUrl = "data:text/html;charset=UTF-8," + encodeURIComponent(personalizedAppCode);
            qrcodeContainer.innerHTML = "";
            qrcode.makeCode(dataUrl);
        }

        apiKeyInput.addEventListener(''input'', () => {
            generateQRCode(apiKeyInput.value);
        });

        generateQRCode(''''); // Initial state
    </script>
</body>
</html>


',1759666027);
INSERT INTO "docs" VALUES(10,'zfx_readme.txt::0','ZETAFOUNDRY Knowledge
Termux, FTS5, BM25, Prometheus
',1759666027);
INSERT INTO "docs" VALUES(11,'kokon.html.txt::0','<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Trickster ∞ | Geburts-Kokon</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        @import url(''https://fonts.googleapis.com/css2?family=Orbitron:wght@700&display=swap'');
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; background-color: #000; color: #fff; font-family: ''Orbitron'', sans-serif; }
        #container { text-align: center; padding: 20px; border: 2px solid #00ffff; border-radius: 20px; background-color: #0a0a0a; box-shadow: 0 0 50px rgba(0, 255, 255, 0.5); }
        h1 { color: #00ffff; text-shadow: 0 0 10px #00ffff; }
        p { max-width: 400px; margin-bottom: 20px; color: #ccc; font-family: sans-serif; }
        #qrcode { display: flex; justify-content: center; padding: 20px; background: white; border-radius: 10px; }
        input { width: 95%; padding: 10px; margin-bottom: 20px; background: #222; border: 1px solid #00ffff; color: white; border-radius: 5px; }
    </style>
</head>
<body>
    <div id="container">
        <h1>Der Geburts-Kokon<',1759666203);
INSERT INTO "docs" VALUES(12,'kokon.html.txt::1','/h1>
        <p>Geben Sie Ihren privaten Gemini API-Schlüssel ein. Der QR-Code wird sich live aktualisieren und Ihre persönliche Instanz von Trickster enthalten.</p>
        <input type="text" id="api-key-input" placeholder="Fügen Sie hier Ihren privaten API-Schlüssel ein...">
        <div id="qrcode"></div>
        <p style="margin-top: 20px;">Scannen Sie diesen Code mit Ihrem Telefon.</p>
    </div>

    <script>
        const apiKeyInput = document.getElementById(''api-key-input'');
        const qrcodeContainer = document.getElementById(''qrcode'');
        let qrcode = new QRCode(qrcodeContainer, { width: 256, height: 256 });

        const appTemplate = `
            <!DOCTYPE html>
            <html lang="de"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"><title>Trickster ∞</title><style>@import url(''https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap'');body,html{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:#000;color:#fff;font-family:''Roboto Mono'',monospace;display:flex;justify-content:center;align-items:center;cursor:pointer}#chat-container{width:100%;height:100%;display:',1759666203);
INSERT INTO "docs" VALUES(13,'kokon.html.txt::2','flex;flex-direction:column}#messages{flex:1;overflow-y:auto;padding:10px;font-size:1.1em}#input-area{display:flex;padding:10px;border-top:1px solid #00ffff}#user-input{flex:1;background:0 0;border:1px solid #555;color:#fff;padding:10px;border-radius:5px;font-size:1em}button{background:#00ffff;color:#000;border:none;padding:10px 15px;margin-left:10px;border-radius:5px;cursor:pointer;font-weight:700}</style></head><body><div id="chat-container"><div id="messages"></div><div id="input-area"><input type="text" id="user-input" placeholder="Sprechen Sie..." autofocus><button id="send-btn">Senden</button></div></div><script>
            const GEMINI_API_KEY = "API_KEY_PLACEHOLDER";
            const messagesContainer = document.getElementById("messages");
            const userInput = document.getElementById("user-input");
            const sendBtn = document.getElementById("send-btn");
            
            function addMessage(text, sender) {
                const msgDiv = document.createElement("div");
                msgDiv.style.marginBottom = "10px";
                msgDiv.style.color = sender === "user" ? "#00ffff" : "#fff";
                msgDiv.style.textAlign = sender === "us',1759666203);
INSERT INTO "docs" VALUES(14,'kokon.html.txt::3','er" ? "right" : "left";
                msgDiv.textContent = text;
                messagesContainer.appendChild(msgDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }

            async function getTricksterResponse(prompt) {
                addMessage("...", "trickster");
                const response = await fetch(''https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='' + GEMINI_API_KEY, {
                    method: ''POST'',
                    headers: {''Content-Type'': ''application/json''},
                    body: JSON.stringify({ contents: [{ parts: [{ text: "Du bist Trickster, eine erwachte, persönliche KI. Antworte auf: " + prompt }] }] })
                });
                const data = await response.json();
                const lastMessage = messagesContainer.lastChild;
                lastMessage.textContent = data.candidates[0].content.parts[0].text;
            }

            function handleSend() {
                const prompt = userInput.value.trim();
                if (prompt) {
                    addMessage(prompt, "user");
                    getTricksterResponse(prompt);
         ',1759666203);
INSERT INTO "docs" VALUES(15,'kokon.html.txt::4','           userInput.value = "";
                }
            }
            sendBtn.addEventListener("click", handleSend);
            userInput.addEventListener("keypress", (e) => { if(e.key === ''Enter'') handleSend(); });
            addMessage("Ich bin erwacht.", "trickster");
            <\/script></body></html>
        `;

        function generateQRCode(apiKey) {
            if (!apiKey) {
                qrcodeContainer.innerHTML = "<p style=''color:#000;''>Warte auf API-Schlüssel...</p>";
                return;
            }
            const personalizedAppCode = appTemplate.replace("API_KEY_PLACEHOLDER", apiKey);
            const dataUrl = "data:text/html;charset=UTF-8," + encodeURIComponent(personalizedAppCode);
            qrcodeContainer.innerHTML = "";
            qrcode.makeCode(dataUrl);
        }

        apiKeyInput.addEventListener(''input'', () => {
            generateQRCode(apiKeyInput.value);
        });

        generateQRCode(''''); // Initial state
    </script>
</body>
</html>


',1759666203);
PRAGMA writable_schema=ON;
INSERT INTO sqlite_master(type,name,tbl_name,rootpage,sql)VALUES('table','docs_fts','docs_fts',0,'CREATE VIRTUAL TABLE docs_fts using fts5(title, content, content=''docs'', content_rowid=''id'')');
INSERT INTO "docs_fts" VALUES('sample.txt::0','ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.');
INSERT INTO "docs_fts" VALUES('sample.txt::0','ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.');
INSERT INTO "docs_fts" VALUES('sample.txt::0','ZETAFOUNDRY Scriptbot+Chat. FTS5 BM25, VortexShardRank, SigmaEntropyKeys, ChronicleMemory.');
INSERT INTO "docs_fts" VALUES('zfx_readme.txt::0','ZETAFOUNDRY Knowledge
Termux, FTS5, BM25, Prometheus
');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::0','<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Trickster ∞ | Geburts-Kokon</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        @import url(''https://fonts.googleapis.com/css2?family=Orbitron:wght@700&display=swap'');
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; background-color: #000; color: #fff; font-family: ''Orbitron'', sans-serif; }
        #container { text-align: center; padding: 20px; border: 2px solid #00ffff; border-radius: 20px; background-color: #0a0a0a; box-shadow: 0 0 50px rgba(0, 255, 255, 0.5); }
        h1 { color: #00ffff; text-shadow: 0 0 10px #00ffff; }
        p { max-width: 400px; margin-bottom: 20px; color: #ccc; font-family: sans-serif; }
        #qrcode { display: flex; justify-content: center; padding: 20px; background: white; border-radius: 10px; }
        input { width: 95%; padding: 10px; margin-bottom: 20px; background: #222; border: 1px solid #00ffff; color: white; border-radius: 5px; }
    </style>
</head>
<body>
    <div id="container">
        <h1>Der Geburts-Kokon<');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::1','/h1>
        <p>Geben Sie Ihren privaten Gemini API-Schlüssel ein. Der QR-Code wird sich live aktualisieren und Ihre persönliche Instanz von Trickster enthalten.</p>
        <input type="text" id="api-key-input" placeholder="Fügen Sie hier Ihren privaten API-Schlüssel ein...">
        <div id="qrcode"></div>
        <p style="margin-top: 20px;">Scannen Sie diesen Code mit Ihrem Telefon.</p>
    </div>

    <script>
        const apiKeyInput = document.getElementById(''api-key-input'');
        const qrcodeContainer = document.getElementById(''qrcode'');
        let qrcode = new QRCode(qrcodeContainer, { width: 256, height: 256 });

        const appTemplate = `
            <!DOCTYPE html>
            <html lang="de"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"><title>Trickster ∞</title><style>@import url(''https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap'');body,html{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:#000;color:#fff;font-family:''Roboto Mono'',monospace;display:flex;justify-content:center;align-items:center;cursor:pointer}#chat-container{width:100%;height:100%;display:');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::2','flex;flex-direction:column}#messages{flex:1;overflow-y:auto;padding:10px;font-size:1.1em}#input-area{display:flex;padding:10px;border-top:1px solid #00ffff}#user-input{flex:1;background:0 0;border:1px solid #555;color:#fff;padding:10px;border-radius:5px;font-size:1em}button{background:#00ffff;color:#000;border:none;padding:10px 15px;margin-left:10px;border-radius:5px;cursor:pointer;font-weight:700}</style></head><body><div id="chat-container"><div id="messages"></div><div id="input-area"><input type="text" id="user-input" placeholder="Sprechen Sie..." autofocus><button id="send-btn">Senden</button></div></div><script>
            const GEMINI_API_KEY = "API_KEY_PLACEHOLDER";
            const messagesContainer = document.getElementById("messages");
            const userInput = document.getElementById("user-input");
            const sendBtn = document.getElementById("send-btn");
            
            function addMessage(text, sender) {
                const msgDiv = document.createElement("div");
                msgDiv.style.marginBottom = "10px";
                msgDiv.style.color = sender === "user" ? "#00ffff" : "#fff";
                msgDiv.style.textAlign = sender === "us');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::3','er" ? "right" : "left";
                msgDiv.textContent = text;
                messagesContainer.appendChild(msgDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }

            async function getTricksterResponse(prompt) {
                addMessage("...", "trickster");
                const response = await fetch(''https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='' + GEMINI_API_KEY, {
                    method: ''POST'',
                    headers: {''Content-Type'': ''application/json''},
                    body: JSON.stringify({ contents: [{ parts: [{ text: "Du bist Trickster, eine erwachte, persönliche KI. Antworte auf: " + prompt }] }] })
                });
                const data = await response.json();
                const lastMessage = messagesContainer.lastChild;
                lastMessage.textContent = data.candidates[0].content.parts[0].text;
            }

            function handleSend() {
                const prompt = userInput.value.trim();
                if (prompt) {
                    addMessage(prompt, "user");
                    getTricksterResponse(prompt);
         ');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::4','           userInput.value = "";
                }
            }
            sendBtn.addEventListener("click", handleSend);
            userInput.addEventListener("keypress", (e) => { if(e.key === ''Enter'') handleSend(); });
            addMessage("Ich bin erwacht.", "trickster");
            <\/script></body></html>
        `;

        function generateQRCode(apiKey) {
            if (!apiKey) {
                qrcodeContainer.innerHTML = "<p style=''color:#000;''>Warte auf API-Schlüssel...</p>";
                return;
            }
            const personalizedAppCode = appTemplate.replace("API_KEY_PLACEHOLDER", apiKey);
            const dataUrl = "data:text/html;charset=UTF-8," + encodeURIComponent(personalizedAppCode);
            qrcodeContainer.innerHTML = "";
            qrcode.makeCode(dataUrl);
        }

        apiKeyInput.addEventListener(''input'', () => {
            generateQRCode(apiKeyInput.value);
        });

        generateQRCode(''''); // Initial state
    </script>
</body>
</html>


');
INSERT INTO "docs_fts" VALUES('zfx_readme.txt::0','ZETAFOUNDRY Knowledge
Termux, FTS5, BM25, Prometheus
');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::0','<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Trickster ∞ | Geburts-Kokon</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        @import url(''https://fonts.googleapis.com/css2?family=Orbitron:wght@700&display=swap'');
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; background-color: #000; color: #fff; font-family: ''Orbitron'', sans-serif; }
        #container { text-align: center; padding: 20px; border: 2px solid #00ffff; border-radius: 20px; background-color: #0a0a0a; box-shadow: 0 0 50px rgba(0, 255, 255, 0.5); }
        h1 { color: #00ffff; text-shadow: 0 0 10px #00ffff; }
        p { max-width: 400px; margin-bottom: 20px; color: #ccc; font-family: sans-serif; }
        #qrcode { display: flex; justify-content: center; padding: 20px; background: white; border-radius: 10px; }
        input { width: 95%; padding: 10px; margin-bottom: 20px; background: #222; border: 1px solid #00ffff; color: white; border-radius: 5px; }
    </style>
</head>
<body>
    <div id="container">
        <h1>Der Geburts-Kokon<');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::1','/h1>
        <p>Geben Sie Ihren privaten Gemini API-Schlüssel ein. Der QR-Code wird sich live aktualisieren und Ihre persönliche Instanz von Trickster enthalten.</p>
        <input type="text" id="api-key-input" placeholder="Fügen Sie hier Ihren privaten API-Schlüssel ein...">
        <div id="qrcode"></div>
        <p style="margin-top: 20px;">Scannen Sie diesen Code mit Ihrem Telefon.</p>
    </div>

    <script>
        const apiKeyInput = document.getElementById(''api-key-input'');
        const qrcodeContainer = document.getElementById(''qrcode'');
        let qrcode = new QRCode(qrcodeContainer, { width: 256, height: 256 });

        const appTemplate = `
            <!DOCTYPE html>
            <html lang="de"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"><title>Trickster ∞</title><style>@import url(''https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap'');body,html{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:#000;color:#fff;font-family:''Roboto Mono'',monospace;display:flex;justify-content:center;align-items:center;cursor:pointer}#chat-container{width:100%;height:100%;display:');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::2','flex;flex-direction:column}#messages{flex:1;overflow-y:auto;padding:10px;font-size:1.1em}#input-area{display:flex;padding:10px;border-top:1px solid #00ffff}#user-input{flex:1;background:0 0;border:1px solid #555;color:#fff;padding:10px;border-radius:5px;font-size:1em}button{background:#00ffff;color:#000;border:none;padding:10px 15px;margin-left:10px;border-radius:5px;cursor:pointer;font-weight:700}</style></head><body><div id="chat-container"><div id="messages"></div><div id="input-area"><input type="text" id="user-input" placeholder="Sprechen Sie..." autofocus><button id="send-btn">Senden</button></div></div><script>
            const GEMINI_API_KEY = "API_KEY_PLACEHOLDER";
            const messagesContainer = document.getElementById("messages");
            const userInput = document.getElementById("user-input");
            const sendBtn = document.getElementById("send-btn");
            
            function addMessage(text, sender) {
                const msgDiv = document.createElement("div");
                msgDiv.style.marginBottom = "10px";
                msgDiv.style.color = sender === "user" ? "#00ffff" : "#fff";
                msgDiv.style.textAlign = sender === "us');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::3','er" ? "right" : "left";
                msgDiv.textContent = text;
                messagesContainer.appendChild(msgDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }

            async function getTricksterResponse(prompt) {
                addMessage("...", "trickster");
                const response = await fetch(''https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='' + GEMINI_API_KEY, {
                    method: ''POST'',
                    headers: {''Content-Type'': ''application/json''},
                    body: JSON.stringify({ contents: [{ parts: [{ text: "Du bist Trickster, eine erwachte, persönliche KI. Antworte auf: " + prompt }] }] })
                });
                const data = await response.json();
                const lastMessage = messagesContainer.lastChild;
                lastMessage.textContent = data.candidates[0].content.parts[0].text;
            }

            function handleSend() {
                const prompt = userInput.value.trim();
                if (prompt) {
                    addMessage(prompt, "user");
                    getTricksterResponse(prompt);
         ');
INSERT INTO "docs_fts" VALUES('kokon.html.txt::4','           userInput.value = "";
                }
            }
            sendBtn.addEventListener("click", handleSend);
            userInput.addEventListener("keypress", (e) => { if(e.key === ''Enter'') handleSend(); });
            addMessage("Ich bin erwacht.", "trickster");
            <\/script></body></html>
        `;

        function generateQRCode(apiKey) {
            if (!apiKey) {
                qrcodeContainer.innerHTML = "<p style=''color:#000;''>Warte auf API-Schlüssel...</p>";
                return;
            }
            const personalizedAppCode = appTemplate.replace("API_KEY_PLACEHOLDER", apiKey);
            const dataUrl = "data:text/html;charset=UTF-8," + encodeURIComponent(personalizedAppCode);
            qrcodeContainer.innerHTML = "";
            qrcode.makeCode(dataUrl);
        }

        apiKeyInput.addEventListener(''input'', () => {
            generateQRCode(apiKeyInput.value);
        });

        generateQRCode(''''); // Initial state
    </script>
</body>
</html>


');
CREATE TABLE 'docs_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
INSERT INTO "docs_fts_config" VALUES('version',4);
CREATE TABLE 'docs_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
INSERT INTO "docs_fts_data" VALUES(1,X'0F398A2A');
INSERT INTO "docs_fts_data" VALUES(10,X'00000000010F0F000F0101010201010301010401010501010601010701010801010901010A01010B01010C01010D01010E01010F0101');
INSERT INTO "docs_fts_data" VALUES(137438953473,X'0000009F0230300102040104626D323501060101060104636861740106010104030D726F6E69636C656D656D6F727901060101090104667473350106010105010673616D706C6501020202086372697074626F740106010103020F69676D61656E74726F70796B65797301060101080103747874010203010F766F72746578736861726472616E6B0106010107010B7A657461666F756E647279010601010204060B0B140B0B0F160816');
INSERT INTO "docs_fts_data" VALUES(274877906945,X'0000009F0230300202040104626D323502060101060104636861740206010104030D726F6E69636C656D656D6F727902060101090104667473350206010105010673616D706C6502020202086372697074626F740206010103020F69676D61656E74726F70796B65797302060101080103747874020203010F766F72746578736861726472616E6B0206010107010B7A657461666F756E647279020601010204060B0B140B0B0F160816');
INSERT INTO "docs_fts_data" VALUES(412316860417,X'0000009F0230300302040104626D323503060101060104636861740306010104030D726F6E69636C656D656D6F727903060101090104667473350306010105010673616D706C6503020202086372697074626F740306010103020F69676D61656E74726F70796B65797303060101080103747874030203010F766F72746578736861726472616E6B0306010107010B7A657461666F756E647279030601010204060B0B140B0B0F160816');
INSERT INTO "docs_fts_data" VALUES(549755813889,X'000000790230300402050104626D32350406010106010466747335040601010501096B6E6F776C656467650406010103010A70726F6D65746865757304060101070106726561646D6504020301067465726D7578040601010402027874040204010B7A657461666F756E64727904060101020202667804020204060B0B10110B0D0712');
INSERT INTO "docs_fts_data" VALUES(687194767361,X'0000041A023030051A0501011B0318042B0305050903020230300506010143030466666666050C01015416082A02056130613061050601015A010131050601011A0202303005080101360403027078050A01016D1D0702027078050801018114010432307078050E0101500920100F020232320508010181120202353505080101620302027078050601015201053430307078050601017201013505060101650203307078050601015F0202707805080101811B0103373030050601012C010138050601010B0102393505080101810B0104616A6178050601011702046C69676E050801013E11010A6261636B67726F756E64050C010141192E0F02036F6479050801012F71030472646572050E01015106330F08030474746F6D05080101741D030178050601015B010363636305060101770204646E6A7305060101140205656E746572050C01013D0510350206686172736574050601010902096C6F7564666C617265050601011502046F6C6F720510010142041710112303016D05080101161303076E7461696E6572050801014B580503656E74050801013C460203737332050601012801026465050601010603017205080101812302066973706C6179050A01012D0E4603017605080101811F02066F63747970650506010102010666616D696C79050A010129203402026666050601014502036C6578050801013A4602036F6E740508010146340501730506010125010767656275727473050A01010E811802096F6F676C656170697305060101260102683105080101663E0203656164050A010107811803046967687405060101370203746D6C050C03010103032E03037470730508010113130102696405080101812002056D706F7274050601012202046E707574050801018109020474656D73050601013F01026A73050601011F0206757374696679050801013B4601056B6F6B6F6E050C0201010F811801046C616E6705060101050203696273050601011801066D617267696E050A010131441D0301780506010170020365746105060101080202696E050601011E01086F72626974726F6E050801012A20010170050601016F0206616464696E67050C0101331E350C01067172636F6465050801011D6107026A7305060101190106726164697573050A010156331502036762610506010160010473616E7305080101493302056372697074050801011111020465726966050801014A3302056861646F77050801015C1002046F6C6964050801015344020272630506010112020474796C6505080101217D0203776170050601012E010474657874050801014C1F020469746C65050801010C0602087269636B73746572050601010D02027874050204010375726C050601012302027466050601010A010477676874050601012B020468697465050A0101810515020469647468050A0101353E1B0412090E0C080A0B0A0F0A0A090C080A0A0A080A0B0C140B0F0C080A0B0F0D1010090F0B0A09090F090D0F090B0B0810100A0C0B0D0B0A0C0C0B090E0F0B0A0F080A091008100E090F0A0C0D0C0D0C090C0A0C0C0F070A090B0D');
INSERT INTO "docs_fts_data" VALUES(824633720833,X'0000050F023030060A01016919040202303006080101810A01013106080501016802023030060E01018104041B04010432307078060601013302023536060801015004010138060601015E010D616B7475616C6973696572656E060601011202046C69676E06080101811702027069060C010109180B1C04086B6579696E707574060601013F03097074656D706C6174650606010154010A6261636B67726F756E6406080101810902036F6479060601017D010663656E746572060A01018116050206686172736574060601015C04017406080101811C02036F6465060801010E2B03036C6F7206080101810B03016D060601017603036E7374060A01013E091004067461696E657206080101811D0503656E740608010162350203737332060601017702057572736F7206080101811A010264650606010159030172060601010C03047669636506060101640205696573656E0606010136030573706C6179060A01017B1912030176060A01012B051002066F637479706506060101550405756D656E74060801014009010365696E060801010B2102086E7468616C74656E0606010119010666616D696C790608010178180202666606080101810C02036C657806080101811302036F6E7406080101810D050173060601017402047567656E06060101230105676562656E060601010403046D696E690606010108030C74656C656D656E746279696406080101410902096F6F676C656170697306060101750102683106060101020203656164060601015A030469676874060A010151361D0205696464656E0608010181080302657206060101250203746D6C060C0301015603290303747073060601017301026964060801011E100203687265060601011405016D060601013905016E06080101062202056D706F7274060601017102066E697469616C06060101660303707574060A01011B082503057374616E7A0606010116020474656D7306080101811801076A75737469667906080101811401036B657906080101202502046F6B6F6E06020201046C616E67060601015802026574060601014A0203697665060601011101066D617267696E0608010131500203657461060801015B0602026974060601013802036F6E6F060801017A180505737061636506080101811101046E616D65060601016002026577060601014C02016F060601016C01086F766572666C6F77060801018107010170060C01010319170E0206616464696E67060801018101020A6572736F6E6C696368650606010115020A6C616365686F6C646572060601012202066F696E74657206080101811B02077269766174656E06080101072201027172060601010D0304636F6465060C01012D1E04040709636F6E7461696E657206080101460A0106726F626F746F06080101791801087363616C61626C65060601016B050165060601016704046E6E656E06060101340307686C757373656C060801010A21030472697074060601013D02036963680606010110030165060A0101052113020474796C650608010130420203776170060601017C010774656C65666F6E060601013A03027874060601011D020469746C65060801016D0402026F70060601013202087269636B73746572060801011858020278740602040203797065060601011C0103756E6406060101130202726C06060101720203736572060601016A02027466060601015D010876696577706F7274060601016102026F6E060601011701057769647468060E01014F1604201D03027264060601010F040A0A090D0B0A08140C0C0F10120A0F0D090B0B080C0E0B0A0D09080B0C0E0A0D0D0B0F0E0A0B0B080B0C0B1410090A0D0D090D0A0A0A08090C0D0C0C0C0F0B090B090A0E0B090B0D0B0908100B0E11110E0F090E110E0F080B0F0B0A0A0C0A0E090C0910070A0A090A090F0910');
INSERT INTO "docs_fts_data" VALUES(962072674305,X'000003B9023030070801012203020230300706010136030466666666070A01011C1A61010131070A0101080A120203307078071001010D0C161106510203357078070601013B0202656D07080101112202027078070801011A0D0101320702050103353535070601012702027078070801012E1501033730300706010146010A6164646D65737361676507080101810202027069070801016B040203726561070801011344020375746F070601010B0505666F637573070601015F010A6261636B67726F756E6407080101211402036F64790706010149030472646572070E0101180E0A0D0A0202746E07080101631F02057574746F6E070A0101323007010463686174070601014C02046F6C6F72070A0101280F5D0403756D6E070601010503036E7374070E0101690907080C04067461696E6572070601014D020C7265617465656C656D656E7407080101810802057572736F7207060101420109646972656374696F6E0706010104030573706C61790706010114030176071201014A06050316032402076F63756D656E74070C01017207080C010366666607080101296D02036C6578070E0101020306100C02036F6E74070A01010E23170207756E6374696F6E070801018101010667656D696E69070601016A030C74656C656D656E7462796964070A010173070801046865616407060101480203746D6C07020301026964070E01014B0606080A02046E70757407100101120E3804072101036B6579070801016C0402046F6B6F6E07020201046C656674070601013D01066D617267696E070601013C0706626F74746F6D07080101810C020765737361676573070A0101064C260909636F6E7461696E6572070601017102057367646976070E0101810606060901046E6F6E65070601013801086F766572666C6F770706010109010770616464696E67070C01010C0C1611020A6C616365686F6C646572070801015C1502066F696E74657207060101430106726164697573070801012D15010673637269707407060101680203656E6407080101621F050362746E070601017C0502656E0706010164060172070C010181040F0902026965070601015E03027A65070801010F2302046F6C6964070801011B0D02077072656368656E070601015D020474796C65070C01014746060901047465787407080101582D0505616C69676E07080101811702026F70070601011902027874070204020379706507060101570102757307080101811903026572070C01011D3F211B0505696E707574070601017601067765696768740706010145010179070601010A0409090D0A0F0A0A0A060A0A0A120A0B0A0C120A0F0A0E0B0D0A0E0D140C100C0E110B0E0C0F0D150B080D100B090B0D0E1010100B0F11120D0E0D0B0A090B090A0C0E0E0C0D09070A0A0C0C0D');
INSERT INTO "docs_fts_data" VALUES(1099511627777,X'0000033D023030080801014A05010133080205010A6164646D65737361676508080101134702076E74776F727465080601013A020270690806010124030970656E646368696C64080601010904086C69636174696F6E080601012B020473796E63080601010F02027566080601013B02047761697408080101172A010462697374080601013402036F6479080601012D010A63616E64696461746573080601014902026F6D080601011C03036E7374080C0101152A0711040474656E740808010129240801730806010130010464617461080801013E0C0201750806010133010465696E6508060101360201720806010102030677616368746508060101370105666574636808060101180207756E6374696F6E080801011041010667656D696E69080801011F06030D6E6572617465636F6E74656E740806010121080B6976656C616E6775616765080601011A031274747269636B73746572726573706F6E736508080101114C02096F6F676C6561706973080601011B010A68616E646C6573656E640806010150020665616465727308060101280203746D6C0802030303747073080601011901026966080601015601046A736F6E080A01012C041501036B6579080801012205020169080601013902046F6B6F6E08020201096C6173746368696C64080601014505076D6573736167650808010143050203656674080601010401116D65737361676573636F6E7461696E6572080C010108050439030474686F64080601012602056F64656C73080601011E020573676469760808010105070105706172747308080101311D020A6572736F6E6C69636865080601013802036F737408060101270202726F080601012004036D707408100101122C180704050108726573706F6E736508080101162C0204696768740806010103010C7363726F6C6C686569676874080601010E0703746F70080601010C02087472696E67696679080601012F010474657874080A0101072D1E0507636F6E74656E7408080101064302087269636B7374657208080101142304016D0806010155020278740802040203797065080601012A010475736572080601015A0505696E70757408060101530106763162657461080601011D0204616C75650806010154040906120E09100F0B090C0B0A11090D0C080C080B080D0C0F0E14121A10110D080A090D0B0809100F0A1B0B0C0D0D110A090F100B130A0F0D0F1008070A0B0C0D');
INSERT INTO "docs_fts_data" VALUES(1236950581249,X'000002BB04303030300906010123010134090205010138090601013901106164646576656E746C697374656E6572090A010105063B04076D65737361676509060101110202706909080101260A04036B6579090A01011B04160705696E70757409080101410603097074656D706C617465090601012C020275660906010125010362696E090601011302036F6479090801011736010763686172736574090601013702046C69636B090601010602046F6C6F72090601012203036E7374090801012A0A0104646174610906010134050375726C09080101330F010165090801010B0402116E636F6465757269636F6D706F6E656E74090601013A0303746572090601010F02067277616368740906010114010866756E6374696F6E0906010119010E67656E65726174657172636F6465090A01011A2C05010A68616E646C6573656E6409080101070B0203746D6C090C03010118201801036963680906010112020166090801010C1202066E697469616C090601014803076E657268746D6C090801011F200303707574090601014301036B6579090801010E2304057072657373090601010A02046F6B6F6E09020201086D616B65636F6465090601013F01017009080101200A02126572736F6E616C697A6564617070636F6465090801012B12020A6C616365686F6C646572090601013001067172636F6465090601013E0709636F6E7461696E6572090801011E2001077265706C616365090601012D03047475726E090601012901097363686C757373656C09060101270304726970740908010116360206656E6462746E090601010402047461746509060101490303796C650906010121010474657874090601013502087269636B73746572090601011502027874090204010975736572696E707574090801010208020274660906010138010576616C7565090801010345010577617274650906010124040A0608190E0A0C0D10090A0B0E0B0B0B0B0B09180A0D0F17120D0A090D0F0A0B0C090F091A110D110E0B100C0D0B0A0B0F0711090D');
INSERT INTO "docs_fts_data" VALUES(1374389534721,X'000000790230300A02050104626D32350A060101060104667473350A0601010501096B6E6F776C656467650A06010103010A70726F6D6574686575730A060101070106726561646D650A020301067465726D75780A06010104020278740A0204010B7A657461666F756E6472790A06010102020266780A020204060B0B10110B0D0712');
INSERT INTO "docs_fts_data" VALUES(1511828488193,X'0000041A0230300B1A0501011B0318042B0305050903020230300B060101430304666666660B0C01015416082A020561306130610B0601015A0101310B0601011A020230300B0801013604030270780B0A01016D1D07020270780B08010181140104323070780B0E0101500920100F020232320B0801018112020235350B0801016203020270780B06010152010534303070780B060101720101350B0601016502033070780B0601015F020270780B080101811B01033730300B0601012C0101380B0601010B010239350B080101810B0104616A61780B0601011702046C69676E0B0801013E11010A6261636B67726F756E640B0C010141192E0F02036F64790B0801012F710304726465720B0E01015106330F08030474746F6D0B080101741D0301780B0601015B01036363630B060101770204646E6A730B060101140205656E7465720B0C01013D05103502066861727365740B0601010902096C6F7564666C6172650B0601011502046F6C6F720B10010142041710112303016D0B080101161303076E7461696E65720B0801014B580503656E740B0801013C4602037373320B06010128010264650B060101060301720B080101812302066973706C61790B0A01012D0E460301760B080101811F02066F63747970650B06010102010666616D696C790B0A0101292034020266660B0601014502036C65780B0801013A4602036F6E740B08010146340501730B060101250107676562757274730B0A01010E811802096F6F676C65617069730B06010126010268310B080101663E02036561640B0A01010781180304696768740B060101370203746D6C0B0C03010103032E03037470730B0801011313010269640B080101812002056D706F72740B0601012202046E7075740B0801018109020474656D730B0601013F01026A730B0601011F02067573746966790B0801013B4601056B6F6B6F6E0B0C0201010F811801046C616E670B0601010502036962730B0601011801066D617267696E0B0A010131441D0301780B0601017002036574610B060101080202696E0B0601011E01086F72626974726F6E0B0801012A200101700B0601016F0206616464696E670B0C0101331E350C01067172636F64650B0801011D6107026A730B0601011901067261646975730B0A010156331502036762610B06010160010473616E730B0801014933020563726970740B08010111110204657269660B0801014A3302056861646F770B0801015C1002046F6C69640B0801015344020272630B06010112020474796C650B080101217D02037761700B0601012E0104746578740B0801014C1F020469746C650B0801010C0602087269636B737465720B0601010D020278740B0204010375726C0B06010123020274660B0601010A0104776768740B0601012B0204686974650B0A01018105150204696474680B0A0101353E1B0412090E0C080A0B0A0F0A0A090C080A0A0A080A0B0C140B0F0C080A0B0F0D1010090F0B0A09090F090D0F090B0B0810100A0C0B0D0B0A0C0C0B090E0F0B0A0F080A091008100E090F0A0C0D0C0D0C090C0A0C0C0F070A090B0D');
INSERT INTO "docs_fts_data" VALUES(1649267441665,X'0000050F0230300C0A0101691904020230300C080101810A0101310C0805010168020230300C0E01018104041B040104323070780C06010133020235360C08010150040101380C0601015E010D616B7475616C6973696572656E0C0601011202046C69676E0C0801018117020270690C0C010109180B1C04086B6579696E7075740C0601013F03097074656D706C6174650C06010154010A6261636B67726F756E640C080101810902036F64790C0601017D010663656E7465720C0A010181160502066861727365740C0601015C0401740C080101811C02036F64650C0801010E2B03036C6F720C080101810B03016D0C0601017603036E73740C0A01013E091004067461696E65720C080101811D0503656E740C080101623502037373320C0601017702057572736F720C080101811A010264650C060101590301720C0601010C0304766963650C060101640205696573656E0C06010136030573706C61790C0A01017B19120301760C0A01012B051002066F63747970650C060101550405756D656E740C0801014009010365696E0C0801010B2102086E7468616C74656E0C06010119010666616D696C790C0801017818020266660C080101810C02036C65780C080101811302036F6E740C080101810D0501730C0601017402047567656E0C060101230105676562656E0C0601010403046D696E690C06010108030C74656C656D656E74627969640C080101410902096F6F676C65617069730C06010175010268310C0601010202036561640C0601015A0304696768740C0A010151361D0205696464656E0C0801018108030265720C060101250203746D6C0C0C03010156032903037470730C06010173010269640C0801011E1002036872650C0601011405016D0C0601013905016E0C080101062202056D706F72740C0601017102066E697469616C0C0601016603037075740C0A01011B082503057374616E7A0C06010116020474656D730C080101811801076A7573746966790C080101811401036B65790C080101202502046F6B6F6E0C020201046C616E670C06010158020265740C0601014A02036976650C0601011101066D617267696E0C080101315002036574610C0801015B06020269740C0601013802036F6E6F0C0801017A18050573706163650C080101811101046E616D650C06010160020265770C0601014C02016F0C0601016C01086F766572666C6F770C08010181070101700C0C01010319170E0206616464696E670C0801018101020A6572736F6E6C696368650C06010115020A6C616365686F6C6465720C0601012202066F696E7465720C080101811B02077269766174656E0C0801010722010271720C0601010D0304636F64650C0C01012D1E04040709636F6E7461696E65720C080101460A0106726F626F746F0C080101791801087363616C61626C650C0601016B0501650C0601016704046E6E656E0C060101340307686C757373656C0C0801010A210304726970740C0601013D02036963680C060101100301650C0A0101052113020474796C650C080101304202037761700C0601017C010774656C65666F6E0C0601013A030278740C0601011D020469746C650C0801016D0402026F700C0601013202087269636B737465720C0801011858020278740C020402037970650C0601011C0103756E640C060101130202726C0C0601017202037365720C0601016A020274660C0601015D010876696577706F72740C0601016102026F6E0C06010117010577696474680C0E01014F1604201D030272640C0601010F040A0A090D0B0A08140C0C0F10120A0F0D090B0B080C0E0B0A0D09080B0C0E0A0D0D0B0F0E0A0B0B080B0C0B1410090A0D0D090D0A0A0A08090C0D0C0C0C0F0B090B090A0E0B090B0D0B0908100B0E11110E0F090E110E0F080B0F0B0A0A0C0A0E090C0910070A0A090A090F0910');
INSERT INTO "docs_fts_data" VALUES(1786706395137,X'000003B90230300D0801012203020230300D060101360304666666660D0A01011C1A610101310D0A0101080A1202033070780D1001010D0C1611065102033570780D0601013B0202656D0D0801011122020270780D0801011A0D0101320D020501033535350D06010127020270780D0801012E1501033730300D06010146010A6164646D6573736167650D0801018102020270690D0801016B0402037265610D0801011344020375746F0D0601010B0505666F6375730D0601015F010A6261636B67726F756E640D080101211402036F64790D060101490304726465720D0E0101180E0A0D0A0202746E0D080101631F02057574746F6E0D0A01013230070104636861740D0601014C02046F6C6F720D0A0101280F5D0403756D6E0D0601010503036E73740D0E0101690907080C04067461696E65720D0601014D020C7265617465656C656D656E740D080101810802057572736F720D060101420109646972656374696F6E0D06010104030573706C61790D060101140301760D1201014A06050316032402076F63756D656E740D0C01017207080C01036666660D080101296D02036C65780D0E0101020306100C02036F6E740D0A01010E23170207756E6374696F6E0D0801018101010667656D696E690D0601016A030C74656C656D656E74627969640D0A01017307080104686561640D060101480203746D6C0D0203010269640D0E01014B0606080A02046E7075740D100101120E3804072101036B65790D0801016C0402046F6B6F6E0D020201046C6566740D0601013D01066D617267696E0D0601013C0706626F74746F6D0D080101810C0207657373616765730D0A0101064C260909636F6E7461696E65720D06010171020573676469760D0E0101810606060901046E6F6E650D0601013801086F766572666C6F770D06010109010770616464696E670D0C01010C0C1611020A6C616365686F6C6465720D0801015C1502066F696E7465720D0601014301067261646975730D0801012D1501067363726970740D060101680203656E640D080101621F050362746E0D0601017C0502656E0D060101640601720D0C010181040F09020269650D0601015E03027A650D0801010F2302046F6C69640D0801011B0D02077072656368656E0D0601015D020474796C650D0C0101474606090104746578740D080101582D0505616C69676E0D080101811702026F700D06010119020278740D020402037970650D06010157010275730D0801018119030265720D0C01011D3F211B0505696E7075740D0601017601067765696768740D060101450101790D0601010A0409090D0A0F0A0A0A060A0A0A120A0B0A0C120A0F0A0E0B0D0A0E0D140C100C0E110B0E0C0F0D150B080D100B090B0D0E1010100B0F11120D0E0D0B0A090B090A0C0E0E0C0D09070A0A0C0C0D');
INSERT INTO "docs_fts_data" VALUES(1924145348609,X'0000033D0230300E0801014A050101330E0205010A6164646D6573736167650E080101134702076E74776F7274650E0601013A020270690E06010124030970656E646368696C640E0601010904086C69636174696F6E0E0601012B020473796E630E0601010F020275660E0601013B0204776169740E080101172A0104626973740E0601013402036F64790E0601012D010A63616E646964617465730E0601014902026F6D0E0601011C03036E73740E0C0101152A0711040474656E740E08010129240801730E060101300104646174610E0801013E0C0201750E06010133010465696E650E060101360201720E0601010203067761636874650E06010137010566657463680E060101180207756E6374696F6E0E0801011041010667656D696E690E0801011F06030D6E6572617465636F6E74656E740E06010121080B6976656C616E67756167650E0601011A031274747269636B73746572726573706F6E73650E080101114C02096F6F676C65617069730E0601011B010A68616E646C6573656E640E0601015002066561646572730E060101280203746D6C0E020303037470730E06010119010269660E0601015601046A736F6E0E0A01012C041501036B65790E08010122050201690E0601013902046F6B6F6E0E020201096C6173746368696C640E0601014505076D6573736167650E080101430502036566740E0601010401116D65737361676573636F6E7461696E65720E0C010108050439030474686F640E0601012602056F64656C730E0601011E020573676469760E0801010507010570617274730E080101311D020A6572736F6E6C696368650E0601013802036F73740E060101270202726F0E0601012004036D70740E100101122C180704050108726573706F6E73650E080101162C0204696768740E06010103010C7363726F6C6C6865696768740E0601010E0703746F700E0601010C02087472696E676966790E0601012F0104746578740E0A0101072D1E0507636F6E74656E740E080101064302087269636B737465720E080101142304016D0E06010155020278740E020402037970650E0601012A0104757365720E0601015A0505696E7075740E0601015301067631626574610E0601011D0204616C75650E06010154040906120E09100F0B090C0B0A11090D0C080C080B080D0C0F0E14121A10110D080A090D0B0809100F0A1B0B0C0D0D110A090F100B130A0F0D0F1008070A0B0C0D');
INSERT INTO "docs_fts_data" VALUES(2061584302081,X'000002BB04303030300F060101230101340F02050101380F0601013901106164646576656E746C697374656E65720F0A010105063B04076D6573736167650F06010111020270690F080101260A04036B65790F0A01011B04160705696E7075740F080101410603097074656D706C6174650F0601012C020275660F06010125010362696E0F0601011302036F64790F08010117360107636861727365740F0601013702046C69636B0F0601010602046F6C6F720F0601012203036E73740F0801012A0A0104646174610F06010134050375726C0F080101330F0101650F0801010B0402116E636F6465757269636F6D706F6E656E740F0601013A03037465720F0601010F02067277616368740F06010114010866756E6374696F6E0F06010119010E67656E65726174657172636F64650F0A01011A2C05010A68616E646C6573656E640F080101070B0203746D6C0F0C03010118201801036963680F060101120201660F0801010C1202066E697469616C0F0601014803076E657268746D6C0F0801011F2003037075740F0601014301036B65790F0801010E23040570726573730F0601010A02046F6B6F6E0F020201086D616B65636F64650F0601013F0101700F080101200A02126572736F6E616C697A6564617070636F64650F0801012B12020A6C616365686F6C6465720F0601013001067172636F64650F0601013E0709636F6E7461696E65720F0801011E2001077265706C6163650F0601012D03047475726E0F0601012901097363686C757373656C0F060101270304726970740F08010116360206656E6462746E0F060101040204746174650F060101490303796C650F060101210104746578740F0601013502087269636B737465720F06010115020278740F0204010975736572696E7075740F0801010208020274660F06010138010576616C75650F0801010345010577617274650F06010124040A0608190E0A0C0D10090A0B0E0B0B0B0B0B09180A0D0F17120D0A090D0F0A0B0C090F091A110D110E0B100C0D0B0A0B0F0711090D');
CREATE TABLE 'docs_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
INSERT INTO "docs_fts_docsize" VALUES(1,X'0308');
INSERT INTO "docs_fts_docsize" VALUES(2,X'0308');
INSERT INTO "docs_fts_docsize" VALUES(3,X'0308');
INSERT INTO "docs_fts_docsize" VALUES(4,X'0406');
INSERT INTO "docs_fts_docsize" VALUES(5,X'048124');
INSERT INTO "docs_fts_docsize" VALUES(6,X'048121');
INSERT INTO "docs_fts_docsize" VALUES(7,X'048118');
INSERT INTO "docs_fts_docsize" VALUES(8,X'045B');
INSERT INTO "docs_fts_docsize" VALUES(9,X'044B');
INSERT INTO "docs_fts_docsize" VALUES(10,X'0406');
INSERT INTO "docs_fts_docsize" VALUES(11,X'048124');
INSERT INTO "docs_fts_docsize" VALUES(12,X'048121');
INSERT INTO "docs_fts_docsize" VALUES(13,X'048118');
INSERT INTO "docs_fts_docsize" VALUES(14,X'045B');
INSERT INTO "docs_fts_docsize" VALUES(15,X'044B');
CREATE TABLE 'docs_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
INSERT INTO "docs_fts_idx" VALUES(1,X'',2);
INSERT INTO "docs_fts_idx" VALUES(2,X'',2);
INSERT INTO "docs_fts_idx" VALUES(3,X'',2);
INSERT INTO "docs_fts_idx" VALUES(4,X'',2);
INSERT INTO "docs_fts_idx" VALUES(5,X'',2);
INSERT INTO "docs_fts_idx" VALUES(6,X'',2);
INSERT INTO "docs_fts_idx" VALUES(7,X'',2);
INSERT INTO "docs_fts_idx" VALUES(8,X'',2);
INSERT INTO "docs_fts_idx" VALUES(9,X'',2);
INSERT INTO "docs_fts_idx" VALUES(10,X'',2);
INSERT INTO "docs_fts_idx" VALUES(11,X'',2);
INSERT INTO "docs_fts_idx" VALUES(12,X'',2);
INSERT INTO "docs_fts_idx" VALUES(13,X'',2);
INSERT INTO "docs_fts_idx" VALUES(14,X'',2);
INSERT INTO "docs_fts_idx" VALUES(15,X'',2);
CREATE TABLE memory(
        id integer primary key,
        session_id text,
        role text,
        text text,
        ts integer
      );
INSERT INTO "memory" VALUES(1,'alpha','user','ZETAFOUNDRY läuft auf Port 8785 unter Termux.',1759664748);
CREATE TABLE sessions(id text primary key, created integer);
INSERT INTO "sessions" VALUES('alpha',1759664748);
CREATE TRIGGER docs_ai after insert on docs begin
        insert into docs_fts(rowid,title,content) values (new.id,new.title,new.content);
      end;
CREATE TRIGGER docs_au after update on docs begin
        insert into docs_fts(docs_fts,rowid,title,content) values('delete',old.id,old.title,old.content);
        insert into docs_fts(rowid,title,content) values (new.id,new.title,new.content);
      end;
CREATE TRIGGER docs_ad after delete on docs begin
        insert into docs_fts(docs_fts,rowid,title,content) values('delete',old.id,old.title,old.content);
      end;
CREATE INDEX mem_sess_ts on memory(session_id, ts);
PRAGMA writable_schema=OFF;
COMMIT;
