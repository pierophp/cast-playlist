const axios = require("axios");
const { writeFile } = require("fs-extra");
(async function main() {
  const category = "ChildrenSongs";
  const language = "CH"; // T,E,CH
  const url = `https://b.jw-cdn.org/apis/mediator/v1/categories/${language}/${category}?detailed=1&clientType=www`;

  const response = await axios.get(url);

  const playlist = {
    name: `${response.data.category.name}`,
    videos: response.data.category.media.map((item) => {
      return {
        title: item.title,
        url: item.files.find((file) => file.label === "720p")
          ?.progressiveDownloadURL,
        image: item.images.sqr.lg,
      };
    }),
  };

  await writeFile(
    `${__dirname}/playlists/${response.data.category.key}-${language}.json`,
    JSON.stringify(playlist, null, 2)
  );
})();
