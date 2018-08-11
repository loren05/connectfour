<template>
    <div id="app" align="center">
        <div>
            <h1>Connect Four</h1>
            <p><span>Player to Move: {{ playerToMove }}</span></p>
            <p><span>{{ gameResult }}</span></p>
        </div>
        <div class="button-container">
            <span v-for="(enabled, column) in allowedMoves" :key="column">
                <button @click="move(column)" :disabled="!enabled" class="game-buttons">{{ column }}</button>
            </span>
        </div>
        <Board :moves="moves"/>
        <div class="button-container">
            <button @click="reset()">reset</button>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';
    import Board from './Board.vue'

    export default {
        components: {
            Board
        },
        data: function () {
            return {
                moves: [],
                playerOneType: 'human',
                playerTwoType: 'human',
                playerToMove: 1,
                gameResult: '',
                movesAllowed: true,
            }
        },
        computed: {
            allowedMoves: function () {
                if (this.movesAllowed && this.gameResult === '') {
                    let counts = {};
                    this.moves.forEach(function (x) {
                        counts[x] = (counts[x] || 0) + 1
                    });
                    let enabledMoves = {};
                    for (let i = 0; i < 7; i++) {
                        enabledMoves[i] = counts[i] === undefined || counts[i] < 6;
                    }
                    return enabledMoves;
                } else {
                    return [false, false, false, false, false, false, false];
                }
            }
        },
        methods: {
            reset: function () {
                this.moves = [];
                this.playerOneType = "human";
                this.playerTwoType = "human";
                this.playerToMove = 1;
                this.gameResult = '';
                this.movesAllowed = true;
                this.saveToLocalStorage();
            },
            move: function (players_move) {
                this.movesAllowed = false;
                this.moves.push(players_move);
                const checkUrl = "/check.json?moves=" + this.moves.toString();
                axios.get(checkUrl).then(response => {
                    this.gameResult = response.data.res;
                    if (this.gameResult === '') {
                        this.playerToMove = this.playerToMove === 1 ? 2 : 1;
                        this.movesAllowed = true;
                    } else {
                        this.movesAllowed = false;
                    }
                    this.saveToLocalStorage();
                });

            },
            saveToLocalStorage: function () {
                localStorage.setItem('moves'        , JSON.stringify(this.moves));
                localStorage.setItem('playerOneType', this.playerOneType);
                localStorage.setItem('playerTwoType', this.playerTwoType);
                localStorage.setItem('playerToMove' , this.playerToMove);
                localStorage.setItem('gameResult'   , this.gameResult);
                localStorage.setItem('movesAllowed' , JSON.stringify(this.movesAllowed));
            }
        },
        mounted() {
            if (localStorage.getItem('moves')) {
                this.moves = JSON.parse(localStorage.getItem('moves'));
            }

            if (localStorage.getItem('playerOneType')) {
                this.playerOneType = localStorage.getItem('playerOneType');
            }

            if (localStorage.getItem('playerTwoType')) {
                this.playerTwoType = localStorage.getItem('playerTwoType');
            }

            if (localStorage.getItem('playerToMove')) {
                this.playerToMove = localStorage.getItem('playerToMove');
            }

            if (localStorage.getItem('gameResult')) {
                this.gameResult = localStorage.getItem('gameResult');
            }

            if (localStorage.getItem('movesAllowed')) {
                this.movesAllowed= Boolean(localStorage.getItem('movesAllowed'));
            }

        }
    }
</script>

<style scoped>

    p {
        font-size: 2em;
        text-align: center;
    }

    .button-container {
        padding-top: 2px;
        height: 30px;
        width: 220px;
        margin: 2px;
        background-color: darkblue;
        text-align: center;
        vertical-align: center;
    }

    .game-buttons {
        border: 1px solid darkblue;
        height: 25px;
        width: 25px;
        margin: 2px;
        border-radius: 50%;
        display: inline-block;
    }

    button {
        border: 1px solid #0066cc;
        background-color: #0099cc;
        color: #ffffff;
        padding: 5px 10px;
    }

    button:hover {
        border: 1px solid #0099cc;
        background-color: darkgreen;
        color: #ffffff;
        padding: 5px 10px;
    }

    button:disabled,
    button[disabled] {
        border: 1px solid #999999;
        background-color: darkorange;
        color: #666666;
    }

    input[type=button]:enabled {
        background: darkgreen;
    }

    input[type=button]:disabled {
        background: darkorange;
    }
</style>
