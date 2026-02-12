const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

class OllamaImageAnalyzer {
    constructor() {
        this.ollamaProcess = null;
        this.isReady = false;
        this.responseBuffer = '';
    }

    // Démarrer le processus Ollama
    async startOllama() {
        return new Promise((resolve, reject) => {

            this.ollamaProcess = spawn('ollama run gemma3:4b', { shell: true });
            console.log('🔄 Démarrage de Ollama LLaVA...');

            this.ollamaProcess.stdout.on('data', (data) => {
                console.log('ondadata');

                const output = data.toString();
                this.responseBuffer += output;


                // Vérifier si Ollama est prêt (affiche le prompt)
                if (output.includes('>>>') && !this.isReady) {
                    this.isReady = true;
                    console.log('✅ Ollama LLaVA est prêt');
                    resolve();
                }

                // Afficher les réponses en temps réel
                if (output.trim() && !output.includes('>>>')) {
                    process.stdout.write(output);
                }
            });

            this.ollamaProcess.stderr.on('data', (data) => {
                console.error('❌ Erreur Ollama:', data.toString());
            });

            this.ollamaProcess.on('close', (code) => {
                console.log(`🔚 Processus Ollama terminé avec le code: ${code}`);
                this.isReady = false;
            });

            // Timeout après 30 secondes
            setTimeout(() => {
                if (!this.isReady) {
                    reject(new Error('Timeout: Ollama n\'a pas démarré dans le délai imparti'));
                }
            }, 300000);
        });
    }

    // Analyser une image
    async analyzeImage(prompt) {
        if (!this.isReady) {
            throw new Error('Ollama n\'est pas prêt');
        }

        return new Promise((resolve, reject) => {

            // Envoyer la commande à Ollama
            this.ollamaProcess.stdin.write(prompt + '\n');

            // Buffer pour stocker la réponse
            let analysis = '';
            let isProcessing = true;

            // Écouter les réponses
            const responseHandler = (data) => {
                const output = data.toString();

                if (output.includes('Added image')) {
                    console.log('📸 Image téléversée avec succès');
                }

                if (output.includes('>>>') && isProcessing) {
                    // Fin de la réponse
                    isProcessing = false;
                    this.ollamaProcess.stdout.removeListener('data', responseHandler);

                    // Nettoyer la réponse
                    analysis = analysis.replace(/Added image.*\n/, '')
                        .replace(/>>>.*$/, '')
                        .trim();

                    resolve(analysis);
                } else if (isProcessing) {
                    analysis += output;
                }
            };

            this.ollamaProcess.stdout.on('data', responseHandler);

            // Timeout après 60 secondes
            setTimeout(() => {
                if (isProcessing) {
                    this.ollamaProcess.stdout.removeListener('data', responseHandler);
                    reject(new Error('Timeout: L\'analyse a pris trop de temps'));
                }
            }, 60000);
        });
    }

    // Arrêter le processus
    stop() {
        if (this.ollamaProcess) {
            this.ollamaProcess.stdin.write('/exit\n');
            this.ollamaProcess.kill();
        }
    }
}

// Utilisation
async function runImageAnalysis(
    prompt = ""
) {
    const analyzer = new OllamaImageAnalyzer();

    try {
        // Démarrer Ollama
        await analyzer.startOllama();

        const analysis = await analyzer.analyzeImage(prompt);

        console.log('\n📋 Résultat de l\'analyse:');
        console.log(analysis);
        return analysis;

    } catch (error) {
        console.error('💥 Erreur:', error.message);
    } finally {
        analyzer.stop();
    }
}

// // Exécuter
// runImageAnalysis();

module.exports = {
    OllamaImageAnalyzer,
    runImageAnalysis
}