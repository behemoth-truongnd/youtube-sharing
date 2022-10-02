import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  shareMovie() {
    event.preventDefault();
    const $form = $("#new_youtube_video_form");
    var formData = new FormData($form[0]);
    $.ajax({
      url: $form.attr("action"),
      type: "POST",
      beforeSend: function (xhr) {
        xhr.setRequestHeader(
          "X-CSRF-Token",
          $('meta[name="csrf-token"]').attr("content")
        );
      },
      data: formData,
      contentType: false,
      processData: false,
      success: function (response) {
        console.log(response);
        // $("#youtubeShareModal").modal("hide");
      },
    });
  }

  previewVideo() {
    var youtubeId = $(event.target).data("youtube-id");
    var element = `<div class="movie-preview" id="video-preview">
      <iframe
        width="800"
        height="500"
        src="https://www.youtube.com/embed/${youtubeId}"
        frameborder="0"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      ></iframe>

      <div class="movie-background" data-action="click->homes#hideMoviePreview"></div>
    </div>`;

    $("#preview-wrapper").append(element);
  }

  hideMoviePreview() {
    $("#video-preview").remove();
  }
}
