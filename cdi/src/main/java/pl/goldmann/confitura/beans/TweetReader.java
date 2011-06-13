package pl.goldmann.confitura.beans;

import java.util.List;
import javax.enterprise.context.ApplicationScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import pl.goldmann.confitura.model.Tweet;

@ApplicationScoped
public class TweetReader {
    
    @PersistenceContext(unitName = "ConfituraPU")
    private EntityManager entityManager;
    
    public List<Tweet> read() throws Exception {
        int maxResults = 20;
        
        List<Tweet> tweets = (List<Tweet>) entityManager.createQuery("from Tweet t order by t.id desc").setMaxResults(maxResults).getResultList();
        
        return tweets;
    }
    
    public Long count() {
        return (Long) entityManager.createNamedQuery("tweetCount").getSingleResult();
    }
            
}
