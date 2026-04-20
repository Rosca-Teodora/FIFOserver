# FIFO Server

## Descriere

Acest proiect implementeaza o arhitectura client-server in Bash, bazata pe FIFO-uri (named pipes), pentru interogarea paginilor de manual Linux (`man`).

Clientul trimite o cerere catre server printr-un FIFO bine-cunoscut, iar serverul returneaza raspunsul intr-un FIFO dedicat clientului.

## Obiective

- Demonstrarea comunicarii inter-proces (IPC) folosind FIFO-uri.
- Separarea clara a rolurilor client/server.
- Configurarea parametrilor serverului prin fisier extern.
- Gestionarea concurenta a cererilor, prin FIFO-uri de raspuns per client.

## Arhitectura

Componente principale:

- `server.sh`: porneste serverul, primeste cereri, parseaza formatul, ruleaza `man`, trimite raspunsul.
- `client.sh`: construieste cererea, o trimite serverului, asteapta raspunsul in FIFO-ul propriu.
- `configServer.conf`: defineste FIFO-ul bine-cunoscut (ex. `/tmp/server-fifo`).

Flux de comunicare:

1. Clientul creeaza FIFO-ul propriu: `/tmp/server-reply-<PID>`.
2. Clientul trimite cererea in FIFO-ul serverului.
3. Serverul valideaza cererea si extrage PID + comanda.
4. Serverul scrie rezultatul `man <command>` in FIFO-ul clientului.
5. Dupa citire, FIFO-ul clientului este sters.

## Formatul cererii

Cererile sunt trimise in formatul:

```text
BEGIN-REQ [client-pid: command-name] END-REQ
```

Unde:

- `client-pid`: PID-ul procesului client.
- `command-name`: comanda Linux pentru care se cere pagina de manual.

## Cerinte

- Sistem Linux (sau mediu compatibil POSIX).
- Bash.
- Utilitare standard: `mkfifo`, `cat`, `man`.

## Configurare

Fisierul `configServer.conf` contine calea FIFO-ului serverului:

```conf
fifoServer=/tmp/server-fifo
```

## Rulare

1. Acorda drepturi de executie:

```bash
chmod +x server.sh client.sh
```

2. Porneste serverul intr-un terminal:

```bash
./server.sh
```

3. Ruleaza clientul intr-un alt terminal:

```bash
./client.sh
```

4. Introdu o comanda Linux (ex. `ls`, `grep`, `ps`) cand este solicitata.

## Exemplu de utilizare

Input client:

```text
ls
```

Cerere transmisa:

```text
BEGIN-REQ [12345: ls] END-REQ
```

Raspuns:

- Continutul paginii de manual pentru comanda solicitata (`man ls`).

## Gestionarea erorilor

- Clientul verifica existenta FIFO-ului serverului inainte de trimiterea cererii.
- Serverul valideaza formatul cererii prin expresie regulata.
- FIFO-urile client sunt sterse dupa finalizarea comunicarii.

## Limitari curente

- Serverul ruleaza intr-o bucla infinita (fara mecanism de shutdown controlat).
- Nu exista timeout pentru citire/scriere pe FIFO.
- Nu sunt tratate explicit erorile comenzii `man` (ex. comanda inexistenta).

## Posibile imbunatatiri

- Adaugarea unui mecanism de oprire gratiata (semnale `SIGINT`/`SIGTERM`).
- Introducerea timeout-urilor pentru operatiile FIFO.
- Logging structurat pentru cereri si erori.
- Validare extinsa si mesaje de eroare mai descriptive catre client.

## Containerizare

Pentru rulare prin Docker, vezi documentatia din `README.Docker.md`.
