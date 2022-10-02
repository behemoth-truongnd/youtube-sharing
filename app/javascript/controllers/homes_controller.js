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
}
