<template>
    <div class="board-container">
        <div v-for="(column, columnIndex) in boardState" :key="columnIndex">
            <span v-for="(element, rowIndex) in column" :key="rowIndex" :class="'dot-' + element">&nbsp;</span>
        </div>
    </div>
</template>

<script>
    export default {
        props: {
            moves: {
                type: Array,
                required: true,
                validator: function (moves) {
                    return moves.reduce(function (valid, move) {
                        return valid && !isNaN(move) && (move >= 0) && (move < 7)
                    }, true)
                }
            }
        },
        computed: {
            boardState: function () {
                let columns = [];
                let currentPlayer = 1;

                for (let i = 0; i < 7; i++) {
                    columns[i] = [];
                }

                for (let i = 0; i < this.moves.length; i++) {
                    let move = this.moves[i];
                    columns[move].unshift(currentPlayer);
                    currentPlayer = (currentPlayer === 1) ? 2 : 1;
                }

                for (let i = 0; i < 7; i++) {
                    while (columns[i].length < 6) {
                        columns[i].unshift('0');
                    }
                }

                return columns[0].map((col, i) => columns.map(row => row[i]));
            }
        }
    }

</script>

<style scoped>
    .dot-0 {
        border: 1px solid blue;
        height: 25px;
        width: 25px;
        margin: 1px;
        background-color: white;
        border-radius: 50%;
        display: inline-block;
    }

    .dot-1 {
        border: 1px solid blue;
        height: 25px;
        width: 25px;
        margin: 1px;
        background-color: red;
        border-radius: 50%;
        display: inline-block;
    }

    .dot-2 {
        border: 1px solid blue;
        height: 25px;
        width: 25px;
        margin: 1px;
        background-color: yellow;
        border-radius: 50%;
        display: inline-block;
    }

    .board-container {
        padding-top: 10px;
        height: 180px;
        width: 220px;
        margin: 2px;
        background-color: darkblue;
        text-align: center;
        vertical-align: center;
    }

</style>