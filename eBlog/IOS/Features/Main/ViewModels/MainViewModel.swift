//
//  MainViewModel.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation


class MainViewModel : ObservableObject {
    @Published var isGetFailed: Bool = false
    @Published var isLoading: Bool = false

    @Published var posts: Array<Post> = []
    
    
    private var postRepository: PostRepository

    
    init(postRepository: PostRepository = PostRepository()) {
        self.postRepository = postRepository

    }
    
    func handleGetPosts() {
        isLoading = true
        isGetFailed = false
        postRepository.getPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(_):
                    self?.isGetFailed = true
                }
            }
        }
    }
}
