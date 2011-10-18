package pl.goldmann.confitura.beans;

import javax.enterprise.context.ApplicationScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import pl.goldmann.confitura.model.Tweet;

@ApplicationScoped
public class TweetSaver {

    @PersistenceContext(unitName = "ConfituraPU")
    private EntityManager entityManager;

    public void save(String username, String message, Long id) throws Exception {

        Tweet t = new Tweet();
        t.setId(id);
        t.setMessage(message);
        t.setUsername(username);

        entityManager.persist(t);
    }
}
