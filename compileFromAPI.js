const fs = require("fs");
const axios = require("axios");

function setlistToProlog(setlist) {
  return `setlist(${setlist.id}, venue("${setlist.venue.name}", "${
    setlist.venue.city
  }", "${setlist.venue.state}"),date("${setlist.month}", "${setlist.day}", "${
    setlist.year
  }"), [${songsToProlog(setlist.songs)}]).
    `;
}

function songsToProlog(songs) {
  let code = "";
  for (let song of songs) {
    code = code + songToProlog(song);
  }
  return code.slice(0, -1);
}

function songToProlog(song) {
  song = song.replace("(", "");
  song = song.replace(")", "");
  song = song.replace('"', "");
  return `song("${song}"),`;
}
async function getDB() {
  let result = await axios("https://gddb-b7baf449e62a.herokuapp.com/setlists");
  let code = "";
  for (let setlist of result.data.setlists) {
    let response = await axios(
      `https://gddb-b7baf449e62a.herokuapp.com/setlists/${setlist.id}`
    );
    setlist.songs = response.data.setlist.sets
      .map((set) => set.notes.map((note) => note.song.title))
      .flat(Infinity);
    code = code + setlistToProlog(setlist);
  }
  fs.writeFile("./Gd.pl", code, (err) => {
    if (err) {
      console.error(err);
    } else {
      // file written successfully
    }
  });
}

getDB();
