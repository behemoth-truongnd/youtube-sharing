import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  shareMovie() {
    event.preventDefault();
    const $form = $("#new_youtube_video_form");
    var formData = new FormData($form[0]);
    $(".invalid-feedback").remove();
    $("#youtube-url").removeClass("is-invalid");
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
        if (response.success) {
          $("#youtubeShareModal").modal("hide");
          window.location.href = "/";
        } else {
          $("#youtube-url").addClass("is-invalid");
          response.messages.youtube_url.forEach((message) => {
            var error = `<div class='invalid-feedback'>${message}<div>`;
            $(".url-wrapper").append(error);
          });
        }
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

  likeVideo() {
    event.preventDefault();
    var videoId = $(event.target).data("id");
    var $target = $(event.target);
    $.ajax({
      url: `/youtube_videos/${videoId}/react?react_type=like`,
      type: "POST",
      beforeSend: function (xhr) {
        xhr.setRequestHeader(
          "X-CSRF-Token",
          $('meta[name="csrf-token"]').attr("content")
        );
      },
      contentType: false,
      processData: false,
      success: function (response) {
        $(`#dislike-${videoId}`).removeClass("active");
        $(`#dislike-${videoId}`).text(response.dislike_count);
        $target.toggleClass("active");
        $target.text(response.like_count);
      },
    });
  }

  dislikeVideo() {
    event.preventDefault();
    var videoId = $(event.target).data("id");
    var $target = $(event.target);
    $.ajax({
      url: `/youtube_videos/${videoId}/react?react_type=dislike`,
      type: "POST",
      beforeSend: function (xhr) {
        xhr.setRequestHeader(
          "X-CSRF-Token",
          $('meta[name="csrf-token"]').attr("content")
        );
      },
      contentType: false,
      processData: false,
      success: function (response) {
        $(`#like-${videoId}`).removeClass("active");
        $target.toggleClass("active");
        $(`#like-${videoId}`).text(response.like_count);
        $target.text(response.dislike_count);
      },
    });
  }

  hideMoviePreview() {
    $("#video-preview").remove();
  }
}
