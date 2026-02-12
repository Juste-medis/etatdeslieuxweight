const { exec } = require('child_process');
const readline = require('readline');
const fs = require('fs');
const path = require('path');

class InteractiveCommandRunner {
    constructor() {
        this.history = [];
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout,
            completer: this.completer.bind(this),
            history: this.history
        });

        // Charger l'historique si disponible
        this.loadHistory();
    }

    // Fonction de complétion (optionnelle)
    completer(line) {
        const commands = ['cd', 'ls', 'pwd', 'history', 'clear', 'exit', 'quit'];
        const hits = commands.filter(c => c.startsWith(line));
        return [hits.length ? hits : commands, line];
    }

    // Charger l'historique depuis un fichier
    loadHistory() {
        try {
            if (fs.existsSync('.node_shell_history')) {
                const data = fs.readFileSync('.node_shell_history', 'utf8');
                this.history = data.split('\n').filter(line => line.trim());
            }
        } catch (error) {
            // Ignorer les erreurs de lecture de l'historique
        }
    }

    // Sauvegarder l'historique dans un fichier
    saveHistory() {
        try {
            fs.writeFileSync('.node_shell_history', this.history.join('\n'), 'utf8');
        } catch (error) {
            // Ignorer les erreurs d'écriture de l'historique
        }
    }

    // Exécuter une commande
    async runCommand(command) {
        this.history.push(command);

        return new Promise((resolve) => {
            exec(command, { timeout: 30000 }, (error, stdout, stderr) => {
                if (error) {
                    resolve({
                        returncode: error.code || -1,
                        stdout: stdout,
                        stderr: stderr || error.message
                    });
                } else {
                    resolve({
                        returncode: 0,
                        stdout: stdout,
                        stderr: stderr
                    });
                }
            });
        });
    }

    // Démarrer une session interactive
    async startInteractiveSession() {
        console.log("Shell interactif Node.js. Tapez 'exit' ou 'quit' pour quitter.");
        console.log("Tapez 'history' pour voir l'historique des commandes.");

        const prompt = () => {
            this.rl.question(`${process.cwd()} $ `, async (command) => {
                command = command.trim();

                // Commandes spéciales
                if (command.toLowerCase() === 'exit' || command.toLowerCase() === 'quit') {
                    console.log("Au revoir!");
                    this.saveHistory();
                    this.rl.close();
                    return;
                } else if (command.toLowerCase() === 'history') {
                    this.history.forEach((cmd, i) => console.log(`${i + 1}: ${cmd}`));
                    prompt();
                    return;
                } else if (command.toLowerCase() === 'clear') {
                    console.clear();
                    prompt();
                    return;
                } else if (command.startsWith('cd ')) {
                    // Gestion spéciale pour la commande cd
                    const newDir = command.substring(3).trim();
                    try {
                        process.chdir(newDir);
                        console.log(`Répertoire changé vers: ${process.cwd()}`);
                    } catch (error) {
                        console.error(`Erreur: ${error.message}`);
                    }
                    prompt();
                    return;
                }

                // Exécuter la commande
                if (command) {
                    try {
                        const result = await this.runCommand(command);
                        console.log(result.stdout);
                        if (result.stderr) {
                            console.error(result.stderr);
                        }
                        if (result.returncode !== 0) {
                            console.log(`→ Commande terminée avec le code: ${result.returncode}`);
                        }
                    } catch (error) {
                        console.error(`Erreur d'exécution: ${error.message}`);
                    }
                }

                prompt();
            });
        };

        prompt();
    }
}

// Exemple d'utilisation
// const shell = new InteractiveCommandRunner();
// shell.startInteractiveSession();