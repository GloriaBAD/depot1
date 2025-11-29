# CodeArena Docker Sandbox

Ce dossier contient les configurations Docker pour exécuter du code de manière sécurisée et isolée.

## Architecture

Le système utilise Docker pour créer des environnements d'exécution isolés pour chaque langage :

- **Python** : Image basée sur `python:3.11-alpine`
- **JavaScript** : Image basée sur `node:20-alpine`
- **Java** : Image basée sur `openjdk:17-alpine`
- **C++** : Image basée sur `gcc:13-bookworm`

## Sécurité

Chaque conteneur est configuré avec :
- **Utilisateur non-root** : Exécution avec l'utilisateur `sandbox` (UID 1000)
- **Pas de réseau** : `--network none` pour isoler complètement
- **Limites de ressources** :
  - Mémoire : 256MB max
  - CPU : 0.5 core max
  - Processus : 50 max
- **Système de fichiers en lecture seule** avec `/tmp` writable uniquement
- **Timeout** : 10 secondes max par exécution

## Construction des images

```bash
cd sandbox
./build-images.sh
```

Ou manuellement :

```bash
docker build -f Dockerfile.python -t codearena-sandbox-python .
docker build -f Dockerfile.javascript -t codearena-sandbox-javascript .
docker build -f Dockerfile.java -t codearena-sandbox-java .
docker build -f Dockerfile.cpp -t codearena-sandbox-cpp .
```

## Test des exemples

Les fichiers d'exemple dans `test-examples/` montrent comment écrire du code pour chaque langage.

### Python
```bash
echo "5 3" | docker run -i --rm codearena-sandbox-python python3 -c "a,b=map(int,input().split());print(a+b)"
```

### JavaScript
```bash
echo "5 3" | docker run -i --rm codearena-sandbox-javascript node -e "require('readline').createInterface({input:process.stdin}).on('line',l=>{const[a,b]=l.split(' ').map(Number);console.log(a+b);process.exit()})"
```

### Java
```bash
docker run -i --rm codearena-sandbox-java sh -c "echo 'import java.util.Scanner;public class Main{public static void main(String[]args){Scanner s=new Scanner(System.in);System.out.println(s.nextInt()+s.nextInt());}}' > Main.java && javac Main.java && echo '5 3' | java Main"
```

### C++
```bash
docker run -i --rm codearena-sandbox-cpp sh -c "echo '#include<iostream>\\nusing namespace std;\\nint main(){int a,b;cin>>a>>b;cout<<a+b<<endl;}' > test.cpp && g++ test.cpp -o test && echo '5 3' | ./test"
```

## Utilisation dans le backend

Le service `CodeExecutionService` gère automatiquement :
1. La création du conteneur Docker approprié
2. L'injection du code utilisateur
3. L'exécution avec les test cases
4. La récupération des résultats
5. Le nettoyage du conteneur

## Structure des test cases

Les test cases sont stockés au format JSON dans la base de données :

```json
[
  {"input": "5 3", "output": "8"},
  {"input": "10 20", "output": "30"}
]
```

Le système compare la sortie du programme avec la sortie attendue pour déterminer si le test passe.
